import 'dart:async';
import 'package:customers/src/providers/form.provider.dart';
import 'package:customers/src/providers/shopDbProvider.dart';
import 'package:customers/src/providers/userDb.provider.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final _userIdTypeController = BehaviorSubject<String>();
  final _userIdentificationController = BehaviorSubject<String>();
  final _userNameController = BehaviorSubject<String>();
  final _userLastNameController = BehaviorSubject<String>();
  final _userContactController = BehaviorSubject<String>();
  final _userEmailController = BehaviorSubject<String>();

  final _shopNitController = BehaviorSubject<String>();
  final _shopIdController = BehaviorSubject<String>();
  final _shopNameController = BehaviorSubject<String>();
  final _shopBranchNameController = BehaviorSubject<String>();
  final _shopAddressController = BehaviorSubject<String>();
  final _shopCityController = BehaviorSubject<String>();
  final _shopContactNameController = BehaviorSubject<String>();
  final _shopEmailController = BehaviorSubject<String>();
  final _shopPhoneController = BehaviorSubject<String>();

  final _yourSymptomsController = BehaviorSubject<int>();
  final _yourHomeSymptomsController = BehaviorSubject<int>();
  final _haveBeenIsolatedController = BehaviorSubject<int>();
  final _haveBeenVisitedController = BehaviorSubject<int>();
  final _haveBeenWithPeopleController = BehaviorSubject<int>();
  final _yourSymptomsDescController = BehaviorSubject<String>();
  final _haveBeenIsolatedDescController = BehaviorSubject<String>();
  final _haveBeenVisitedDescController = BehaviorSubject<String>();
  final _isEmployeeController = BehaviorSubject<int>();
  final _visitorAcceptController = BehaviorSubject<int>();
  final _employeeAcceptYourSymptomsController = BehaviorSubject<int>();
  final _employeeAcceptHomeSymptomsController = BehaviorSubject<int>();
  final _employeeAcceptVacationSymptomsController = BehaviorSubject<int>();
  final _lastDateController = BehaviorSubject<String>();


  Stream<String> get userIdTypeStream => _userIdTypeController.stream;
  Stream<String> get userIdentificationStream => _userIdentificationController.stream;
  Stream<String> get userNameStream => _userNameController.stream;
  Stream<String> get userLastNameStream => _userLastNameController.stream;
  Stream<String> get userContactStream => _userContactController.stream;
  Stream<String> get userEmailStream => _userEmailController.stream;
  Stream<bool> get formValidStream => Rx.combineLatest6(
      userIdTypeStream,
      userIdentificationStream,
      userNameStream,
      userLastNameStream,
      userContactStream,
      userEmailStream,
      (userIdTypeStream, userIdStream, userNameStream, userLastNameStream,
              usercontactStream, userEmailStream) =>
          true);

  Stream<String> get shopIdStream => _shopIdController.stream;
  Stream<String> get shopNitStream => _shopNitController.stream;
  Stream<String> get shopNameStream => _shopNameController.stream;
  Stream<String> get shopAddressStream => _shopAddressController.stream;
  Stream<String> get shopCityStream => _shopCityController.stream;
  Stream<String> get shopBranchNameStream => _shopBranchNameController.stream;
  Stream<String> get shopContactNameStream => _shopContactNameController.stream;
  Stream<String> get shopEmailStream => _shopEmailController.stream;
  Stream<String> get shopPhoneStream => _shopPhoneController.stream;
  Stream<bool> get formShopValidStream => Rx.combineLatest5(
      shopNitStream,
      shopNameStream,
      shopContactNameStream,
      shopEmailStream,
      shopPhoneStream,
      (shopNitStream, shopNameStream, shopContactNameStream, shopEmailStream,
              shopPhoneStream) =>
          true);

  Stream<int> get yourSymptomsStream => _yourSymptomsController.stream;
  Stream<int> get yourHomeSymptomsStream => _yourHomeSymptomsController.stream;
  Stream<int> get haveBeenIsolatedStream => _haveBeenIsolatedController.stream;
  Stream<int> get haveBeenVisitedStream => _haveBeenVisitedController.stream;
  Stream<int> get haveBeenWithPeopleStream => _haveBeenWithPeopleController.stream;
  Stream<String> get yourSymptomsDescStream => _yourSymptomsDescController.stream;
  Stream<String> get haveBeenIsolatedDescStream => _haveBeenIsolatedDescController.stream;
  Stream<String> get haveBeenVisitedDescStream => _haveBeenVisitedDescController.stream;
  Stream<int> get isEmployeeStream => _isEmployeeController.stream;
  Stream<int> get visitorAcceptStream => _visitorAcceptController.stream;
  Stream<int> get employeeAcceptYourSymptomsStream => _employeeAcceptYourSymptomsController.stream;
  Stream<int> get employeeAcceptHomeSymptomsStream => _employeeAcceptHomeSymptomsController.stream;
  Stream<int> get employeeAcceptVacationSymptomsStream => _employeeAcceptVacationSymptomsController.stream;
  Stream<String> get lastDateStream => _lastDateController.stream;

  Function(String) get changeUserIdType => _userIdTypeController.sink.add;
  Function(String) get changeUserIdentification => _userIdentificationController.sink.add;
  Function(String) get changeUserName => _userNameController.sink.add;
  Function(String) get changeUserLastName => _userLastNameController.sink.add;
  Function(String) get changeUserContact => _userContactController.sink.add;
  Function(String) get changeUserEmail => _userEmailController.sink.add;

  Function(String) get changeShopNit => _shopNitController.sink.add;
  Function(String) get changeShopId => _shopIdController.sink.add;
  Function(String) get changeShopName => _shopNameController.sink.add;
  Function(String) get changeShopAddress => _shopAddressController.sink.add;
  Function(String) get changeShopCity => _shopCityController.sink.add;
  Function(String) get changeShopBranchName => _shopBranchNameController.sink.add;
  Function(String) get changeShopContactName => _shopContactNameController.sink.add;
  Function(String) get changeShopEmail => _shopEmailController.sink.add;
  Function(String) get changeShopPhone => _shopPhoneController.sink.add;

  Function(int) get changeYourSymptoms => _yourSymptomsController.sink.add;
  Function(int) get changeYourHomeSymptoms => _yourHomeSymptomsController.sink.add;
  Function(int) get changeHaveBeenIsolated => _haveBeenIsolatedController.sink.add;
  Function(int) get changeHaveBeenVisited => _haveBeenVisitedController.sink.add;
  Function(int) get changeHaveBeenWithPeople => _haveBeenWithPeopleController.sink.add;
  Function(String) get changeYourSymptomsDesc => _yourSymptomsDescController.sink.add;
  Function(String) get changeHaveBeenIsolatedDesc => _haveBeenIsolatedDescController.sink.add;
  Function(String) get changeHaveBeenVisitedDesc => _haveBeenVisitedDescController.sink.add;
  Function(int) get changeIsEmployee => _isEmployeeController.sink.add;
  Function(int) get changeVisitorAccept => _visitorAcceptController.sink.add;
  Function(int) get changeEmployeeAcceptYourSymptoms => _employeeAcceptYourSymptomsController.sink.add;
  Function(int) get changeEmployeeAcceptHomeSymptoms => _employeeAcceptHomeSymptomsController.sink.add;
  Function(int) get changeEmployeeAcceptVacationSymptoms => _employeeAcceptVacationSymptomsController.sink.add;
  Function(String) get changeLastDate => _lastDateController.sink.add;

  String get identificationType => _userIdTypeController.value;
  String get identification => _userIdentificationController.value;
  String get userName => _userNameController.value;
  String get lastName => _userLastNameController.value;
  String get contact => _userContactController.value;
  String get email => _userEmailController.value;

  String get shopId => _shopIdController.value;
  String get shopNit => _shopNitController.value;
  String get shopName => _shopNameController.value;
  String get shopAddress => _shopAddressController.value;
  String get shopCity => _shopCityController.value;
  String get shopBranchName => _shopBranchNameController.value;
  String get contactName => _shopContactNameController.value;
  String get shopEmail => _shopEmailController.value;
  String get phone => _shopPhoneController.value;

  int get yourSymptoms => _yourSymptomsController.value ?? 0;
  int get yourHomeSymptoms => _yourHomeSymptomsController.value ?? 0;
  int get haveBeenIsolated => _haveBeenIsolatedController.value ?? 1;
  int get haveBeenVisited => _haveBeenVisitedController.value ?? 0;
  int get haveBeenWithPeople => _haveBeenWithPeopleController.value ?? 0;
  String get yourSymptomsDesc => _yourSymptomsDescController.value ?? '';
  String get haveBeenIsolatedDesc => _haveBeenIsolatedDescController.value ?? '';
  String get haveBeenVisitedDesc => _haveBeenVisitedDescController.value ?? '';
  int get isEmployee => _isEmployeeController.value ?? 0;
  int get visitorAccept => _visitorAcceptController.value ?? 0;
  int get employeeAcceptYourSymptoms => _employeeAcceptYourSymptomsController.value ?? 0;
  int get employeeAcceptHomeSymptoms => _employeeAcceptHomeSymptomsController.value ?? 0;
  int get employeeAcceptVacationSymptoms => _employeeAcceptVacationSymptomsController.value ?? 0;
  String get lastDate => _lastDateController.value ?? '';

  UserBloc() {
    UserDBProvider.db.getUser().then((value) {
      if (value != null) {
        changeUserIdType(value.identificationType);
        changeUserIdentification(value.identification);
        changeUserName(value.name);
        changeUserLastName(value.lastName);
        changeUserContact(value.contact);
        changeUserEmail(value.email);
      }
    });
    ShopDBProvider.db.getShop().then((value) {
      if (value != null) {
        changeShopId(value.id);
        changeShopNit(value.nit);
        changeShopName(value.name);
        changeShopAddress(value.address);
        changeShopCity(value.city);
        changeShopBranchName(value.branchName);
        changeShopContactName(value.contactName);
        changeShopEmail(value.email);
        changeShopPhone(value.phone);
      }
    });    
    DBProvider.db.getForm().then((value) {
      if (value != null) {
        changeYourSymptoms(value.yourSymptoms);
        changeYourHomeSymptoms(value.yourHomeSymptoms);
        changeHaveBeenIsolated(value.haveBeenIsolated);
        changeHaveBeenVisited(value.haveBeenVisited);
        changeHaveBeenWithPeople(value.haveBeenWithPeople);
        changeYourSymptomsDesc(value.yourSymptomsDesc);
        changeHaveBeenIsolatedDesc(value.haveBeenIsolatedDesc);
        changeHaveBeenVisitedDesc(value.haveBeenVisitedDesc);
        changeIsEmployee(value.isEmployee);
        changeVisitorAccept(value.visitorAccept);
        changeEmployeeAcceptYourSymptoms(value.employeeAcceptYourSymptoms);
        changeEmployeeAcceptHomeSymptoms(value.employeeAcceptHomeSymptoms);
        changeEmployeeAcceptVacationSymptoms(value.employeeAcceptVacationSymptoms);
        changeLastDate(value.lastDate);
      }
    });
  }

  dispose() {
    _userIdTypeController?.close();
    _userIdentificationController?.close();
    _userNameController?.close();
    _userLastNameController?.close();
    _userContactController?.close();
    _userEmailController?.close();
    _shopIdController?.close();
    _shopNitController?.close();
    _shopNameController?.close();
    _shopAddressController?.close();
    _shopCityController?.close();
    _shopBranchNameController?.close();
    _shopContactNameController?.close();
    _shopEmailController?.close();
    _shopPhoneController?.close();
    _yourSymptomsController?.close();
    _yourHomeSymptomsController?.close();
    _haveBeenIsolatedController?.close();
    _haveBeenVisitedController?.close();
    _haveBeenWithPeopleController?.close();
    _yourSymptomsDescController?.close();
    _haveBeenIsolatedDescController?.close();
    _haveBeenVisitedDescController?.close();
    _isEmployeeController?.close();
    _visitorAcceptController?.close();
    _employeeAcceptYourSymptomsController?.close();
    _employeeAcceptHomeSymptomsController?.close();
    _employeeAcceptVacationSymptomsController?.close();
    _lastDateController?.close();
  }
}
