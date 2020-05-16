import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class 
UserModel {
    String firebaseId;
    String documentId;
    String identificationType;
    String identification;
    String name;
    String lastName;
    String contact;
    String email;
    String password;

    UserModel({
        this.firebaseId,
        this.documentId,
        this.identificationType,
        this.identification,
        this.name,
        this.lastName,
        this.contact,
        this.email,
        this.password,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firebaseId: json["firebaseId"],
        documentId: json["documentId"],
        identificationType: json["identificationType"],
        identification: json["identification"],
        name: json["name"],
        lastName: json["lastName"],
        contact: json["contact"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "firebaseId": firebaseId,
        "documentId": documentId,
        "identificationType": identificationType,
        "identification": identification,
        "name": name,
        "lastName": lastName,
        "contact": contact,
        "email": email,
        "password": password,
    };
}