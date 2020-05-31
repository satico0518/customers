import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/models/shop-branch.model.dart';
import 'package:customers/src/providers/shopDbProvider.dart';
import 'package:customers/src/providers/userDb.provider.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final _userIsLoggedController = BehaviorSubject<bool>();
  final _userFirebaseIdController = BehaviorSubject<String>();
  final _userDocumentIdController = BehaviorSubject<String>();
  final _userIdTypeController = BehaviorSubject<String>();
  final _userIdentificationController = BehaviorSubject<String>();
  final _userNameController = BehaviorSubject<String>();
  final _userGenreController = BehaviorSubject<String>();
  final _userBirthDateController = BehaviorSubject<DateTime>();
  final _userLastNameController = BehaviorSubject<String>();
  final _userContactController = BehaviorSubject<String>();
  final _userAddressController = BehaviorSubject<String>();
  final _userEmailController = BehaviorSubject<String>();
  final _userPasswordController = BehaviorSubject<String>();
  final _userIsEditingController = BehaviorSubject<bool>();
  final _userMaxDateController = BehaviorSubject<Timestamp>();

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

  Stream<bool> get userIsLoggedStream => _userIsLoggedController.stream;
  Stream<bool> get userIsEditingStream => _userIsEditingController.stream;
  Stream<String> get userFirebaseIdStream => _userFirebaseIdController.stream;
  Stream<String> get userDocumentIdStream => _userDocumentIdController.stream;
  Stream<String> get userIdTypeStream => _userIdTypeController.stream;
  Stream<String> get userIdentificationStream => _userIdentificationController.stream;
  Stream<String> get userNameStream => _userNameController.stream;
  Stream<String> get userGenreStream => _userGenreController.stream;
  Stream<DateTime> get userBirthDateStream => _userBirthDateController.stream;
  Stream<String> get userLastNameStream => _userLastNameController.stream;
  Stream<String> get userContactStream => _userContactController.stream;
  Stream<String> get userAddressStream => _userAddressController.stream;
  Stream<String> get userEmailStream => _userEmailController.stream;
  Stream<String> get userPasswordStream => _userPasswordController.stream;
  Stream<Timestamp> get userMaxDateStream => _userMaxDateController.stream;

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

  Function(bool) get changeUserIsLogged => _userIsLoggedController.sink.add;
  Function(bool) get changeUserIsEditing => _userIsEditingController.sink.add;
  Function(String) get changeUserFirebaseId => _userFirebaseIdController.sink.add;
  Function(String) get changeUserDocumentId => _userDocumentIdController.sink.add;
  Function(String) get changeUserIdType => _userIdTypeController.sink.add;
  Function(String) get changeUserIdentification => _userIdentificationController.sink.add;
  Function(String) get changeUserName => _userNameController.sink.add;
  Function(String) get changeUserGenre => _userGenreController.sink.add;
  Function(DateTime) get changeUserBirthDate => _userBirthDateController.sink.add;
  Function(String) get changeUserLastName => _userLastNameController.sink.add;
  Function(String) get changeUserContact => _userContactController.sink.add;
  Function(String) get changeUserAddress => _userAddressController.sink.add;
  Function(String) get changeUserEmail => _userEmailController.sink.add;
  Function(String) get changeUserPassword => _userPasswordController.sink.add;
  Function(Timestamp) get changeUserMaxDate => _userMaxDateController.sink.add;

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

  bool get userIsLogged => _userIsLoggedController.value;
  bool get userIsEditing => _userIsEditingController.value;
  String get userFirebaseId => _userFirebaseIdController.value;
  String get userDocumentId => _userDocumentIdController.value;
  String get identificationType => _userIdTypeController.value;
  String get identification => _userIdentificationController.value;
  String get userName => _userNameController.value;
  String get userGenre => _userGenreController.value;
  DateTime get userBirthDate => _userBirthDateController.value;
  String get lastName => _userLastNameController.value;
  String get contact => _userContactController.value;
  String get userAddress => _userAddressController.value;
  String get email => _userEmailController.value;
  String get password => _userPasswordController.value;
  Timestamp get userMaxDate => _userMaxDateController.value;

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

  UserBloc() {
    UserDBProvider.db.getUser().then((value) {
      if (value != null) {
        changeUserFirebaseId(value.firebaseId ?? '');
        changeUserDocumentId(value.documentId ?? '');
        changeUserIdType(value.identificationType ?? '');
        changeUserIdentification(value.identification ?? '');
        changeUserName(value.name ?? '');
        changeUserGenre(value.genre ?? '');
        changeUserBirthDate(value.birthDate ?? new DateTime.now());
        changeUserLastName(value.lastName ?? '');
        changeUserContact(value.contact ?? '');
        changeUserAddress(value.address ?? '');
        changeUserEmail(value.email ?? '');
        changeUserPassword(value.password ?? '');
        changeUserMaxDate(value.maxDate ?? '');
      }
    });
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
    _userIsLoggedController?.close();
    _userIsEditingController?.close();
    _userFirebaseIdController?.close();
    _userDocumentIdController?.close();
    _userIdTypeController?.close();
    _userIdentificationController?.close();
    _userNameController?.close();
    _userGenreController?.close();
    _userBirthDateController?.close();
    _userLastNameController?.close();
    _userContactController?.close();
    _userAddressController?.close();
    _userEmailController?.close();
    _userPasswordController?.close();
    _userMaxDateController?.close();
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
