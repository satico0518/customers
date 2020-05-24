import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String firebaseId;
  String documentId;
  String identificationType;
  String identification;
  String name;
  String genre;
  DateTime birthDate;
  String lastName;
  String contact;
  String address;
  String email;
  String password;
  Timestamp maxDate;

  UserModel({
    this.firebaseId,
    this.documentId,
    this.identificationType,
    this.identification,
    this.name,
    this.genre,
    this.birthDate,
    this.lastName,
    this.contact,
    this.address,
    this.email,
    this.password,
    this.maxDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      firebaseId: json["firebaseId"] ?? '',
      documentId: json["documentId"] ?? '',
      identificationType: json["identificationType"] ?? '-- Tipo Documento --',
      identification: json["identification"] ?? '',
      name: json["name"] ?? '',
      genre: json["genre"] ?? '-- Género --',
      birthDate: json["birthDate"] != null
          ? json["birthDate"] is Timestamp
              ? (json["birthDate"] as Timestamp).toDate()
              : DateTime.parse(json["birthDate"])
          : DateTime(DateTime.now().year - 10),
      lastName: json["lastName"] ?? '',
      contact: json["contact"] ?? '',
      address: json["address"] ?? '',
      email: json["email"] ?? '',
      password: json["password"] ?? '',
      maxDate: json["maxDate"] != null
          ? (json["maxDate"] is int
              ? Timestamp.fromMillisecondsSinceEpoch(json["maxDate"])
              : json["maxDate"])
          : Timestamp.fromDate(DateTime.now().add(Duration(days: 7))));

  Map<String, dynamic> toJson() => {
        "firebaseId": firebaseId ?? '',
        "documentId": documentId ?? '',
        "identificationType": identificationType ?? '',
        "identification": identification ?? '',
        "name": name ?? '',
        "genre": genre ?? '',
        "birthDate": birthDate != null
            ? birthDate
            : DateTime(new DateTime.now().year - 10),
        "lastName": lastName ?? '',
        "contact": contact ?? '',
        "address": address ?? '',
        "email": email ?? '',
        "password": password ?? '',
        "maxDate": maxDate ?? Timestamp.fromDate(DateTime.now().add(Duration(days: 7)))
      };
}
