import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/models/user.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class UserDBProvider {
  static Database _database;

  static final UserDBProvider db = UserDBProvider._();
  final _createQuery = 'CREATE TABLE IF NOT EXISTS User ('
      ' firebaseId TEXT,'
      ' documentId TEXT,'
      ' identificationType TEXT,'
      ' identification TEXT,'
      ' genre TEXT,'
      ' birthDate TEXT,'
      ' name TEXT,'
      ' lastName TEXT,'
      ' contact TEXT,'
      ' address TEXT,'
      ' email TEXT,'
      ' maxDate INTEGER,'
      ' password TEXT)';

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
      await db.execute(_createQuery);
    });
  }

  Future<int> addUser(UserModel user) async {
    final db = await database;    
    await db.execute(_createQuery);
    final userJson = user.toJson();
    if (userJson.keys.any((element) => element == 'birthDate'))
      userJson['birthDate'] = userJson['birthDate'].toString();
    if (userJson.keys.any((element) => element == 'maxDate'))
      userJson['maxDate'] = (userJson['maxDate'] as Timestamp).millisecondsSinceEpoch;
    return await db.insert('User', userJson);
  }

  Future<UserModel> getUser() async {
    final db = await database;
    await db.execute(_createQuery);
    var user = await db.query('User');
    if (user.length == 0) return null;
    final userMap = Map.from(user.first);
    if (userMap.length != 0 && userMap.keys.any((element) => element == 'birthDate'))
      userMap['birthDate'] = DateTime.parse(userMap['birthDate']);
    if (userMap.length != 0 && userMap.keys.any((element) => element == 'maxDate'))
      userMap['maxDate'] = Timestamp.fromMillisecondsSinceEpoch(userMap['maxDate']);
    List<UserModel> userModel =
        user.isNotEmpty ? user.map((x) => UserModel.fromJson(x)).toList() : [];
    return userModel.length > 0 ? userModel.first : null;
  }

  // UPDATE
  updateUser(UserModel user) async {
    final db = await database;
    await db.execute(_createQuery);
    final userJson = user.toJson();
    if (userJson.keys.any((element) => element == 'birthDate'))
      userJson['birthDate'] = userJson['birthDate'].toString();
    if (userJson.keys.any((element) => element == 'maxDate'))
      userJson['maxDate'] = (userJson['maxDate'] as Timestamp).millisecondsSinceEpoch;
    final res = await db.update('User', userJson);
    return res;
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.rawQuery('DROP TABLE IF EXISTS User');
  }
}
