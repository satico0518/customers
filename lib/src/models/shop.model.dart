import 'dart:convert';

ShopModel shopModelFromJson(String str) => ShopModel.fromJson(json.decode(str));

String shopModelToJson(ShopModel data) => json.encode(data.toJson());

class ShopModel {
    int id;
    String nit;
    String name;
    String contactName;
    String phone;
    String email;

    ShopModel({
        this.id,
        this.nit,
        this.name,
        this.contactName,
        this.phone,
        this.email,
    });

    factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        id: json["id"],
        nit: json["nit"],
        name: json["name"],
        contactName: json["contactName"],
        phone: json["phone"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nit": nit,
        "name": name,
        "contactName": contactName,
        "phone": phone,
        "email": email,
    };
}