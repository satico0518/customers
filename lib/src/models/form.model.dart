import 'dart:convert';

FormModel formModelFromJson(String str) => FormModel.fromJson(json.decode(str));

String formModelToJson(FormModel data) => json.encode(data.toJson());

class FormModel {
    String yourSymptoms;
    String yourHomeSymptoms;
    String haveBeenIsolated;
    String haveBeenVisited;
    String haveBeenWithPeople;
    String yourSymptomsDesc;
    String haveBeenIsolatedDesc;
    String haveBeenVisitedDesc;
    String isEmployee;
    String visitorAccept;
    String employeeAcceptYourSymptoms;
    String employeeAcceptHomeSymptoms;
    String employeeAcceptVacationSymptoms;
    String signature;

    FormModel({
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
        this.signature
    });

    factory FormModel.fromJson(Map<String, dynamic> json) => FormModel(
        yourSymptoms: json["yourSymptoms"],
        yourHomeSymptoms: json["yourHomeSymptoms"],
        haveBeenIsolated: json["haveBeenIsolated"],
        haveBeenVisited: json["haveBeenVisited"],
        haveBeenWithPeople: json["haveBeenWithPeople"],
        yourSymptomsDesc: json["yourSymptomsDesc"],
        haveBeenIsolatedDesc: json["haveBeenIsolatedDesc"],
        haveBeenVisitedDesc: json["haveBeenVisitedDesc"],
        isEmployee: json["isEmployee"],
        visitorAccept: json["visitorAccept"],
        employeeAcceptYourSymptoms: json["employeeAcceptYourSymptoms"],
        employeeAcceptHomeSymptoms: json["employeeAcceptHomeSymptoms"],
        employeeAcceptVacationSymptoms: json["employeeAcceptVacationSymptoms"],
        signature: json["signature"]
    );

    Map<String, dynamic> toJson() => {
        "yourSymptoms": yourSymptoms,
        "yourHomeSymptoms": yourHomeSymptoms,
        "haveBeenIsolated": haveBeenIsolated,
        "haveBeenVisited": haveBeenVisited,
        "haveBeenWithPeople": haveBeenWithPeople,
        "yourSymptomsDesc": yourSymptomsDesc,
        "haveBeenIsolatedDesc": haveBeenIsolatedDesc,
        "haveBeenVisitedDesc": haveBeenVisitedDesc,
        "isEmployee": isEmployee,
        "visitorAccept": visitorAccept,
        "employeeAcceptYourSymptoms": employeeAcceptYourSymptoms,
        "employeeAcceptHomeSymptoms": employeeAcceptHomeSymptoms,
        "employeeAcceptVacationSymptoms": employeeAcceptVacationSymptoms,
        "signature": signature
    };
}
