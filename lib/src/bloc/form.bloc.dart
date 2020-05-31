import 'dart:async';
import 'package:customers/src/providers/form.provider.dart';
import 'package:rxdart/rxdart.dart';

class FormBloc {
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
  final _formShopDocIdController = BehaviorSubject<String>();
  final _formShopBranchDocIdController = BehaviorSubject<String>();
  final _formUserDocIdController = BehaviorSubject<String>();
  final _formListCount = BehaviorSubject<int>();

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
  Stream<String> get formShopDocIdStream => _formShopDocIdController.stream;
  Stream<String> get formShopBranchDocIdStream => _formShopBranchDocIdController.stream;
  Stream<String> get formUserDocIdStream => _formUserDocIdController.stream;
  Stream<int> get formListCountStream => _formListCount.stream;

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
  Function(String) get changeFormShopDocId => _formShopDocIdController.sink.add;
  Function(String) get changeFormShopBranchDocId => _formShopBranchDocIdController.sink.add;
  Function(String) get changeFormUserDocId => _formUserDocIdController.sink.add;
  Function(int) get changeFormListCount => _formListCount.sink.add;

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
  String get formShopDocId => _formShopDocIdController.value ?? '';
  String get formShopBranchDocId => _formShopBranchDocIdController.value ?? '';
  String get formUserDocId => _formUserDocIdController.value ?? '';
  int get formListCount => _formListCount.value ?? '';

  FormBloc() {  
    DBProvider.db.getForm().then((value) {
      if (value != null) {
        changeYourSymptoms(value.yourSymptoms ?? 0);
        changeYourHomeSymptoms(value.yourHomeSymptoms ?? 0);
        changeHaveBeenIsolated(value.haveBeenIsolated ?? 0);
        changeHaveBeenVisited(value.haveBeenVisited ?? 0);
        changeHaveBeenWithPeople(value.haveBeenWithPeople ?? 0);
        changeYourSymptomsDesc(value.yourSymptomsDesc ?? '');
        changeHaveBeenIsolatedDesc(value.haveBeenIsolatedDesc ?? '');
        changeHaveBeenVisitedDesc(value.haveBeenVisitedDesc ?? '');
        changeIsEmployee(value.isEmployee ?? 0);
        changeVisitorAccept(value.visitorAccept ?? 0);
        changeEmployeeAcceptYourSymptoms(value.employeeAcceptYourSymptoms ?? 0);
        changeEmployeeAcceptHomeSymptoms(value.employeeAcceptHomeSymptoms ?? 0);
        changeEmployeeAcceptVacationSymptoms(value.employeeAcceptVacationSymptoms ?? 0);
        changeLastDate(value.lastDate ?? '');
        changeFormShopDocId(value.shopDocumentId ?? '');
        changeFormShopBranchDocId(value.shopBranchDocumentId ?? '');
        changeFormUserDocId(value.userDocumentId ?? '');
      }
    });
  }

  dispose() {
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
    _formShopDocIdController?.close();
    _formShopBranchDocIdController?.close();
    _formUserDocIdController?.close();
    _formListCount?.close();
  }
}
