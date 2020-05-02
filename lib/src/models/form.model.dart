import 'dart:typed_data';

class FormModel {
  bool yourSymptoms;
  bool yourHomeSymptoms;
  bool haveBeenIsolated;
  bool haveBeenVisited;
  bool haveBeenWithPeople;
  String yourSymptomsDesc;
  String haveBeenIsolatedDesc;
  String haveBeenVisitedDesc;
  bool isEmployee;
  bool visitorAccept;
  bool employeeAcceptYourSymptoms;
  bool employeeAcceptHomeSymptoms;
  bool employeeAcceptVacationSymptoms;
  Uint8List signature;

  FormModel(
      this.yourSymptoms,
      this.yourHomeSymptoms,
      this.haveBeenIsolated,
      this.haveBeenVisited,
      this.haveBeenWithPeople,
      this.yourSymptomsDesc,
      this.haveBeenIsolatedDesc,
      this.haveBeenVisitedDesc,
      this.isEmployee,
      this.visitorAccept,
      this.employeeAcceptYourSymptoms,
      this.employeeAcceptHomeSymptoms,
      this.employeeAcceptVacationSymptoms,
      this.signature);

  Map<String, dynamic> toJson() => {
    'yourSymptoms': yourSymptoms,
    'yourHomeSymptoms': yourHomeSymptoms,
    'haveBeenIsolated': haveBeenIsolated,
    'haveBeenVisited': haveBeenVisited,
    'haveBeenWithPeople': haveBeenWithPeople,
    'yourSymptomsDesc': yourSymptomsDesc,
    'haveBeenIsolatedDesc': haveBeenIsolatedDesc,
    'haveBeenVisitedDesc': haveBeenVisitedDesc,
    'isEmployee': isEmployee,
    'visitorAccept': visitorAccept,
    'employeeAcceptYourSymptoms': employeeAcceptYourSymptoms,
    'employeeAcceptHomeSymptoms': employeeAcceptHomeSymptoms,
    'employeeAcceptVacationSymptoms': employeeAcceptVacationSymptoms,
    'signature': signature.toString()
  };
}
