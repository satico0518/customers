import 'dart:convert';

ShopModel shopModelFromJson(String str) => ShopModel.fromJson(json.decode(str));

String shopModelToJson(ShopModel data) => json.encode(data.toJson());

class ShopModel {
    String id;
    String firebaseId;
    String nit;
    String name;
    String address;
    String city;
    String branchName;
    String contactName;
    String phone;
    String email;

    ShopModel({
        this.id,
        this.firebaseId,
        this.nit,
        this.name,
        this.address,
        this.city,
        this.branchName,
        this.contactName,
        this.phone,
        this.email,
    });

    factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        id: json["id"],
        firebaseId: json["firebaseId"],
        nit: json["nit"],
        name: json["name"],
        address: json["address"],
        city: json["city"],
        branchName: json["branchName"],
        contactName: json["contactName"],
        phone: json["phone"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firebaseId": firebaseId,
        "nit": nit,
        "name": name,
        "address": address,
        "city": city,
        "branchName": branchName,
        "contactName": contactName,
        "phone": phone,
        "email": email,
    };
}