import 'dart:convert';

ShopBranchModel shopBranchModelFromJson(String str) =>
    ShopBranchModel.fromJson(json.decode(str));

String shopBranchModelToJson(ShopBranchModel data) =>
    json.encode(data.toJson());

class ShopBranchModel {
  String shopDocumentId;
  String branchDocumentId;
  String branchName;
  String branchAddress;
  String branchMemo;
  int capacity;
  int maxCapacity;

  ShopBranchModel({
    this.shopDocumentId,
    this.branchDocumentId,
    this.branchName,
    this.branchAddress,
    this.branchMemo,
    this.capacity,
    this.maxCapacity,
  });

  factory ShopBranchModel.fromJson(Map<String, dynamic> json) =>
      ShopBranchModel(
        shopDocumentId: json["shopDocumentId"] ?? '',
        branchDocumentId: json["branchDocumentId"] ?? '',
        branchName: json["branchName"] ?? '',
        branchAddress: json["branchAddress"] ?? '',
        branchMemo: json["branchMemo"] ?? '',
        capacity: json["capacity"] != null
            ? (int.tryParse(json["capacity"].toString()) != null
                ? int.tryParse(json["capacity"].toString())
                : 0)
            : 0,
        maxCapacity: json["maxCapacity"] != null
            ? (int.tryParse(json["maxCapacity"].toString()) != null
                ? int.tryParse(json["maxCapacity"].toString())
                : 0)
            : 0,
      );

  Map<String, dynamic> toJson() => {
        "shopDocumentId": shopDocumentId ?? '',
        "branchDocumentId": branchDocumentId ?? '',
        "branchName": branchName ?? '',
        "branchAddress": branchAddress ?? '',
        "branchMemo": branchMemo ?? '',
        "capacity": capacity ?? 0,
        "maxCapacity": maxCapacity ?? 0,
      };
}
