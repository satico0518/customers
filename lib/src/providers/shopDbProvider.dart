import 'dart:io';

import 'package:customers/src/models/shop.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ShopDBProvider {
  static Database _database;

  static final ShopDBProvider db = ShopDBProvider._();

  ShopDBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsdirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsdirectory.path, 'ShopDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Shop ('
          ' id TEXT PRIMARY KEY,'
          ' firebaseId TEXT,'
          ' nit TEXT,'
          ' name TEXT,'
          ' address TEXT,'
          ' city TEXT,'
          ' branchName TEXT,'
          ' contactName TEXT,'
          ' phone TEXT,'
          ' email TEXT)');
    });
  }

  Future<int> addShop(ShopModel form) async {
    final db = await database;
    final res = await db.insert('Shop', form.toJson());
    return res;
  }

  Future<ShopModel> getShop() async {
    final db = await database;
    final form = await db.query('Shop');
    List<ShopModel> shopList = form.isNotEmpty
        ? form.map((x) => ShopModel.fromJson(x)).toList()
        : [];
    return shopList.length > 0 ? shopList.first : null;
  }

  // UPDATE
  updateShop(ShopModel form) async {
    final db = await database;
    final res = await db.update('Shop', form.toJson());
    return res;
  }

  Future<int> deleteShop() async {
    final db = await database;
    final res = db.delete('Shop');
    return res;
  }
}
