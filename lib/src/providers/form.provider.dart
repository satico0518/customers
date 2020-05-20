import 'dart:io';

import 'package:customers/src/models/form.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  static Database _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsdirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsdirectory.path, 'FormDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Form ('
          'yourSymptoms INTEGER, '
          'yourHomeSymptoms INTEGER, '
          'haveBeenIsolated INTEGER, '
          'haveBeenVisited INTEGER, '
          'haveBeenWithPeople INTEGER, '
          'yourSymptomsDesc TEXT, '
          'haveBeenIsolatedDesc TEXT, '
          'haveBeenVisitedDesc TEXT, '
          'isEmployee INTEGER, '
          'visitorAccept INTEGER, '
          'employeeAcceptYourSymptoms INTEGER, '
          'employeeAcceptHomeSymptoms INTEGER, '
          'employeeAcceptVacationSymptoms INTEGER, '
          'lastDate TEXT, '
          'shopDocumentId TEXT, '
          'shopBranchDocumentId TEXT, '
          'userDocumentId TEXT)');
    });
  }

  Future<int> addForm(FormModel form) async {
    final db = await database;
    final res = await db.insert('Form', form.toJson());
    return res;
  }

  Future<FormModel> getForm() async {
    final db = await database;
    final form = await db.query('Form');
    List<FormModel> formdata =
        form.isNotEmpty ? form.map((x) => FormModel.fromJson(x)).toList() : [];
    return formdata.length > 0 ? formdata.first : null;
  }

  // UPDATE
  updateForm(FormModel form) async {
    final db = await database;
    final res = await db.update('Form', form.toJson());
    return res;
  }

  Future<int> deleteForm() async {
    final db = await database;
    final res = db.delete('Form');
    return res;
  }
}
