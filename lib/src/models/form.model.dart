import 'dart:convert';

FormModel formModelFromJson(String str) => FormModel.fromJson(json.decode(str));

String formModelToJson(FormModel data) => json.encode(data.toJson());

class FormModel {
    int yourSymptoms;
    int yourHomeSymptoms;
    int haveBeenIsolated;
    int haveBeenVisited;
    int haveBeenWithPeople;
    String yourSymptomsDesc;
    String haveBeenIsolatedDesc;
    String haveBeenVisitedDesc;
    int isEmployee;
    int visitorAccept;
    int employeeAcceptYourSymptoms;
    int employeeAcceptHomeSymptoms;
    int employeeAcceptVacationSymptoms;
    String lastDate;
    String shopDocumentId;
    String userDocumentId;

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
        this.lastDate,
        this.shopDocumentId,
        this.userDocumentId
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
        lastDate: json["lastDate"],
        shopDocumentId: json["shopDocumentId"],
        userDocumentId: json["userDocumentId"]
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
        "lastDate": lastDate,
        "shopDocumentId": shopDocumentId,
        "userDocumentId": userDocumentId,
    };
}
