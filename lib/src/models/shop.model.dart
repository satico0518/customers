import 'dart:convert';

ShopModel shopModelFromJson(String str) => ShopModel.fromJson(json.decode(str));

String shopModelToJson(ShopModel data) => json.encode(data.toJson());

class ShopModel {
    String firebaseId;
    String documentId;
    String nit;
    String name;
    String address;
    String city;
    String branchName;
    String contactName;
    String phone;
    String email;
    String password;

    ShopModel({
        this.firebaseId,
        this.documentId,
        this.nit,
        this.name,
        this.address,
        this.city,
        this.branchName,
        this.contactName,
        this.phone,
        this.email,
        this.password
    });

    factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        firebaseId: json["firebaseId"],
        documentId: json["documentId"],
        nit: json["nit"],
        name: json["name"],
        address: json["address"],
        city: json["city"],
        branchName: json["branchName"],
        contactName: json["contactName"],
        phone: json["phone"],
        email: json["email"],
        password: json["password"]
    );

    Map<String, dynamic> toJson() => {
        "firebaseId": firebaseId,
        "documentId": documentId,
        "nit": nit,
        "name": name,
        "address": address,
        "city": city,
        "branchName": branchName,
        "contactName": contactName,
        "phone": phone,
        "email": email,
        "password": password
    };
}