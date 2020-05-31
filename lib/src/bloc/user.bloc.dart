import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  }
}
