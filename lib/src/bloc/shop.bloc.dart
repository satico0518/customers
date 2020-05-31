import 'dart:async';
import 'package:customers/src/models/shop-branch.model.dart';
import 'package:customers/src/providers/shopDbProvider.dart';
import 'package:rxdart/rxdart.dart';

class ShopBloc {
  final _shopIsLoggedController = BehaviorSubject<bool>();
  final _shopFirebaseIdController = BehaviorSubject<String>();
  final _shopDocumentIdController = BehaviorSubject<String>();
  final _shopNitController = BehaviorSubject<String>();
  final _shopNameController = BehaviorSubject<String>();
  final _shopBranchNameController = BehaviorSubject<String>();
  final _shopAddressController = BehaviorSubject<String>();
  final _shopCityController = BehaviorSubject<String>();
  final _shopContactNameController = BehaviorSubject<String>();
  final _shopPhoneController = BehaviorSubject<String>();
  final _shopEmailController = BehaviorSubject<String>();
  final _shopPasswordController = BehaviorSubject<String>();
  final _shopCurrentBranchDocIdController = BehaviorSubject<ShopBranchModel>();
  final _shopIsEditingController = BehaviorSubject<bool>();

  Stream<bool> get shopIsLoggedStream => _shopIsLoggedController.stream;
  Stream<String> get shopFirebaseIdStream => _shopFirebaseIdController.stream;
  Stream<String> get shopDocumentIdStream => _shopDocumentIdController.stream;
  Stream<String> get shopNitStream => _shopNitController.stream;
  Stream<String> get shopNameStream => _shopNameController.stream;
  Stream<String> get shopAddressStream => _shopAddressController.stream;
  Stream<String> get shopCityStream => _shopCityController.stream;
  Stream<String> get shopBranchNameStream => _shopBranchNameController.stream;
  Stream<String> get shopContactNameStream => _shopContactNameController.stream;
  Stream<String> get shopPhoneStream => _shopPhoneController.stream;
  Stream<String> get shopEmailStream => _shopEmailController.stream;
  Stream<String> get shopPasswordStream => _shopPasswordController.stream;
  Stream<ShopBranchModel> get shopCurrBranchStream => _shopCurrentBranchDocIdController.stream;
  Stream<bool> get shopIsEditingStream => _shopIsEditingController.stream;

  Function(bool) get changeShopIsLogged => _shopIsLoggedController.sink.add;
  Function(String) get changeShopFirebaseId => _shopFirebaseIdController.sink.add;
  Function(String) get changeShopDocumentId => _shopDocumentIdController.sink.add;
  Function(String) get changeShopNit => _shopNitController.sink.add;
  Function(String) get changeShopName => _shopNameController.sink.add;
  Function(String) get changeShopAddress => _shopAddressController.sink.add;
  Function(String) get changeShopCity => _shopCityController.sink.add;
  Function(String) get changeShopBranchName => _shopBranchNameController.sink.add;
  Function(String) get changeShopContactName => _shopContactNameController.sink.add;
  Function(String) get changeShopPhone => _shopPhoneController.sink.add;
  Function(String) get changeShopEmail => _shopEmailController.sink.add;
  Function(String) get changeShopPassword => _shopPasswordController.sink.add;
  Function(ShopBranchModel) get changeShopCurrBranch => _shopCurrentBranchDocIdController.sink.add;
  Function(bool) get changeShopIsEditing => _shopIsEditingController.sink.add;

  bool get shopIsLogged => _shopIsLoggedController.value;
  String get shopFirebaseId => _shopFirebaseIdController.value;
  String get shopDocumentId => _shopDocumentIdController.value;
  String get shopNit => _shopNitController.value;
  String get shopName => _shopNameController.value;
  String get shopAddress => _shopAddressController.value;
  String get shopCity => _shopCityController.value;
  String get shopBranchName => _shopBranchNameController.value;
  String get contactName => _shopContactNameController.value;
  String get phone => _shopPhoneController.value;
  String get shopEmail => _shopEmailController.value;
  String get shopPassword => _shopPasswordController.value;
  ShopBranchModel get shopCurrBranch => _shopCurrentBranchDocIdController.value;
  bool get shopIsEditing => _shopIsEditingController.value;

  ShopBloc() {
    ShopDBProvider.db.getShop().then((value) {
      if (value != null) {
        changeShopFirebaseId(value.firebaseId ?? '');
        changeShopDocumentId(value.documentId ?? '');
        changeShopNit(value.nit ?? '');
        changeShopName(value.name ?? '');
        changeShopAddress(value.address ?? '');
        changeShopCity(value.city ?? '');
        changeShopBranchName(value.branchName ?? '');
        changeShopContactName(value.contactName ?? '');
        changeShopPhone(value.phone ?? '');
        changeShopEmail(value.email ?? '');
        changeShopPassword(value.password ?? '');
        changeShopCurrBranch(value.currentBranch);
      }
    });
  }

  dispose() {
    _shopIsLoggedController?.close();
    _shopFirebaseIdController?.close();
    _shopDocumentIdController?.close();
    _shopNitController?.close();
    _shopNameController?.close();
    _shopAddressController?.close();
    _shopCityController?.close();
    _shopBranchNameController?.close();
    _shopContactNameController?.close();
    _shopEmailController?.close();
    _shopPasswordController?.close();
    _shopPhoneController?.close();
    _shopCurrentBranchDocIdController?.close();
    _shopIsEditingController?.close();
  }
}
