import 'dart:io';

import 'package:customers/src/models/user.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class UserDBProvider {
  static Database _database;

  static final UserDBProvider db = UserDBProvider._();

  UserDBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsdirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsdirectory.path, 'UserDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE User ('
          ' firebaseId TEXT,'
          ' documentId TEXT,'
          ' identificationType TEXT,'
          ' identification TEXT,'
          ' name TEXT,'
          ' lastName TEXT,'
          ' contact TEXT,'
          ' address TEXT,'
          ' email TEXT,'
          ' password TEXT)');
    });
  }

  Future<int> addUser(UserModel user) async {
    final db = await database;
    final res = await db.insert('User', user.toJson());
    return res;
  }

  Future<UserModel> getUser() async {
    final db = await database;
    final user = await db.query('User');
    List<UserModel> userModel = user.isNotEmpty
        ? user.map((x) => UserModel.fromJson(x)).toList()
        : [];
    return userModel.length > 0 ? userModel.first : null;
  }

  // UPDATE
  updateUser(UserModel form) async {
    final db = await database;
    final res = await db
        .update('User', form.toJson());
    return res;
  }

  Future<int> deleteUser() async {
    final db = await database;
    final res = db.delete('User');
    return res;
  }
}
