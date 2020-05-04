import 'dart:async';

import 'dart:typed_data';

class FormBloc {
  final _yourSymptoms = StreamController<bool>.broadcast();
  final _yourHomeSymptoms = StreamController<bool>.broadcast();
  final _haveBeenIsolated = StreamController<bool>.broadcast();
  final _haveBeenVisited = StreamController<bool>.broadcast();
  final _haveBeenWithPeople = StreamController<bool>.broadcast();
  final _yourSymptomsDesc = StreamController<String>.broadcast();
  final _haveBeenIsolatedDesc = StreamController<String>.broadcast();
  final _haveBeenVisitedDesc = StreamController<String>.broadcast();
  final _isEmployee = StreamController<bool>.broadcast();
  final _visitorAccept = StreamController<bool>.broadcast();
  final _employeeAcceptYourSymptoms = StreamController<bool>.broadcast();
  final _employeeAcceptHomeSymptoms = StreamController<bool>.broadcast();
  final _employeeAcceptVacationSymptoms = StreamController<bool>.broadcast();
  final _signature = StreamController<Uint8List>.broadcast();

  Stream<bool> get yourSymptomsStream => _yourSymptoms.stream;
  get changeYourSymptoms => _yourSymptoms.sink.add;
  
  Stream<bool> get yourHomeSymptomsStream => _yourHomeSymptoms.stream;
  get changeYourHomeSymptoms => _yourHomeSymptoms.sink.add;
  
  Stream<bool> get haveBeenIsolatedStream => _haveBeenIsolated.stream;
  get changeHaveBeenIsolated => _haveBeenIsolated.sink.add;
  
  Stream<bool> get haveBeenVisitedStream => _haveBeenVisited.stream;
  get changeHaveBeenVisited => _haveBeenVisited.sink.add;
  
  Stream<bool> get haveBeenWithPeopleStream => _haveBeenWithPeople.stream;
  get changeHaveBeenWithPeople => _haveBeenWithPeople.sink.add;
  
  Stream<String> get yourSymptomsDescStream => _yourSymptomsDesc.stream;
  get changeYourSymptomsDesc => _yourSymptomsDesc.sink.add;

  Stream<String> get haveBeenIsolatedDescStream => _haveBeenIsolatedDesc.stream;
  get changeHaveBeenIsolatedDesc => _haveBeenIsolatedDesc.sink.add;

  Stream<String> get haveBeenVisitedDescStream => _haveBeenVisitedDesc.stream;
  get changeHaveBeenVisitedDesc => _haveBeenVisitedDesc.sink.add;

  Stream<bool> get isEmployeeStream => _isEmployee.stream;
  get changeIsEmployee => _isEmployee.sink.add;

  Stream<bool> get visitorAcceptStream => _visitorAccept.stream;
  get changeVisitorAccept => _visitorAccept.sink.add;

  Stream<bool> get employeeAcceptYourSymptomsStream => _employeeAcceptYourSymptoms.stream;
  get changeEmployeeAcceptYourSymptoms => _employeeAcceptYourSymptoms.sink.add;

  Stream<bool> get employeeAcceptHomeSymptomsStream => _employeeAcceptHomeSymptoms.stream;
  get changeEmployeeAcceptHomeSymptoms => _employeeAcceptHomeSymptoms.sink.add;

  Stream<bool> get employeeAcceptVacationSymptomsStream => _employeeAcceptVacationSymptoms.stream;
  get changeEmployeeAcceptVacationSymptoms => _employeeAcceptVacationSymptoms.sink.add;

  Stream<Uint8List> get signatureStream => _signature.stream;
  get changeSignature => _signature.sink.add;

  dispose() {
    _yourSymptoms.close();
    _yourHomeSymptoms.close();
    _haveBeenIsolated.close();
    _haveBeenVisited.close();
    _haveBeenWithPeople.close();
    _yourSymptomsDesc.close();
    _haveBeenIsolatedDesc.close();
    _haveBeenVisitedDesc.close();
    _isEmployee.close();
    _visitorAccept.close();
    _employeeAcceptYourSymptoms.close();
    _employeeAcceptHomeSymptoms.close();
    _employeeAcceptVacationSymptoms.close();
    _signature.close();
  }
}