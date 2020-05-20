import 'dart:io';

import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/models/shop-branch.model.dart';
import 'package:customers/src/models/shop.model.dart';
import 'package:customers/src/providers/shopFirebase.provider.dart';
import 'package:flutter/cupertino.dart';
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
          ' firebaseId TEXT,'
          ' documentId TEXT,'
          ' currentBranchDocId TEXT,'
          ' nit TEXT,'
          ' name TEXT,'
          ' address TEXT,'
          ' city TEXT,'
          ' branchName TEXT,'
          ' contactName TEXT,'
          ' phone TEXT,'
          ' email TEXT,'
          ' password TEXT)');
      await db.execute('CREATE TABLE ShopBranch ('
          ' shopDocumentId TEXT,'
          ' branchDocumentId TEXT,'
          ' branchName TEXT,'
          ' branchAddress TEXT,'
          ' branchMemo TEXT)');
    });
  }

  Future<int> addShop(ShopModel shop) async {
    final db = await database;
    final res = await db.insert('Shop', shop.toJson());
    return res;
  }

  Future<int> addShopBranch(ShopBranchModel shopBranch) async {
    final db = await database;
    final res = await db.insert('ShopBranch', shopBranch.toJson());
    return res;
  }

  Future<ShopModel> getShop() async {
    final db = await database;
    final shop = await db.query('Shop');
    List<ShopModel> shopList =
        shop.isNotEmpty ? shop.map((x) => ShopModel.fromJson(x)).toList() : [];
    return shopList.length > 0 ? shopList.first : null;
  }

  Future<List<ShopBranchModel>> getShopBranchs() async {
    final db = await database;
    final branches = await db.query('ShopBranch');
    List<ShopBranchModel> shopBranchList = branches.isNotEmpty
        ? branches.map((x) => ShopBranchModel.fromJson(x)).toList()
        : [];
    return shopBranchList.length > 0 ? shopBranchList : null;
  }

  Future<ShopBranchModel> getShopBranchByDocId(String docId) async {
    final db = await database;
    final branches = await db.query('ShopBranch', where: 'branchDocumentId == ?', whereArgs: [docId]);
    final branch =  branches.length > 0 ? branches.first : {};

    ShopBranchModel shopBranch = branch.length > 0
        ? ShopBranchModel.fromJson(branch)
        : null;
    return shopBranch;
  }

  // UPDATE
  updateShop(ShopModel shop) async {
    final db = await database;
    final res = await db.update('Shop', shop.toJson());
    return res;
  }

  updateShopBranch(ShopBranchModel shopBranch) async {
    final db = await database;
    final res = await db.update('ShopBranch', shopBranch.toJson(), where: 'branchDocumentId == ?', whereArgs: [shopBranch.branchDocumentId]);
    return res;
  }

  Future<int> deleteShop() async {
    final db = await database;
    final res = db.delete('Shop');
    return res;
  }

  Future<int> deleteShopBranch() async {
    final db = await database;
    final res = db.delete('ShopBranch');
    return res;
  }

  saveShopIfNotExists(BuildContext context, String email) async {
    final bloc = Provider.of(context);
    if (bloc.shopEmail == null || bloc.shopEmail.isEmpty) {
      // update Shop
      final shopSnapshot =
          await ShopFirebaseProvider.fb.getShopFbByEmail(email);
      final docId = shopSnapshot.documents[0].documentID;
      final shopData = shopSnapshot.documents[0].data;
      bloc.changeShopAddress(shopData['address']);
      bloc.changeShopBranchName(shopData['branchName']);
      bloc.changeShopCity(shopData['city']);
      bloc.changeShopContactName(shopData['contactName']);
      bloc.changeShopDocumentId(docId);
      bloc.changeShopEmail(shopData['email']);
      bloc.changeShopFirebaseId(shopData['firebaseId']);
      bloc.changeShopName(shopData['name']);
      bloc.changeShopNit(shopData['nit']);
      bloc.changeShopPhone(shopData['phone']);
      bloc.changeShopPassword(shopData['password']);
      final shop = new ShopModel(
        firebaseId: bloc.shopFirebaseId.trim(),
        documentId: bloc.shopDocumentId,
        nit: bloc.shopNit.trim(),
        name: bloc.shopName.trim(),
        address: bloc.shopAddress.trim(),
        city: bloc.shopCity.trim(),
        branchName: bloc.shopBranchName.trim(),
        contactName: bloc.contactName.trim(),
        phone: bloc.phone.trim(),
        email: bloc.shopEmail.trim(),
        password: bloc.shopPassword.trim(),
      );
      ShopDBProvider.db.addShop(shop);
      // update Shop Branches
      final branchSnapshot =
          await ShopFirebaseProvider.fb.getBranchsFbByShopDocId(docId);
      final List<ShopBranchModel> branchList =
        branchSnapshot.documents.map((e) => ShopBranchModel.fromJson(e.data)).toList();
      for (var i = 0; i < branchList.length; i++) {
        branchList[i].branchDocumentId = branchSnapshot.documents[i].documentID;
      }
      bloc.changeShopBranches(branchList);
      bloc.changeShopCurrBranch(branchList[0]);
      ShopDBProvider.db.deleteShopBranch();
      branchList.forEach((element) {
        ShopDBProvider.db.addShopBranch(element);
      });
    }
  }
}
