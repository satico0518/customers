import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class 
UserModel {
    int id;
    String identificationType;
    String identification;
    String name;
    String lastName;
    String contact;
    String email;

    UserModel({
        this.id,
        this.identificationType,
        this.identification,
        this.name,
        this.lastName,
        this.contact,
        this.email,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        identificationType: json["identificationType"],
        identification: json["identification"],
        name: json["name"],
        lastName: json["lastName"],
        contact: json["contact"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "identificationType": identificationType,
        "identification": identification,
        "name": name,
        "lastName": lastName,
        "contact": contact,
        "email": email,
    };
}