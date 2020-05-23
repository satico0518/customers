import 'dart:convert';

ShopBranchModel shopBranchModelFromJson(String str) =>
    ShopBranchModel.fromJson(json.decode(str));

String shopBranchModelToJson(ShopBranchModel data) => json.encode(data.toJson());

class ShopBranchModel {
  String shopDocumentId;
  String branchDocumentId;
  String branchName;
  String branchAddress;
  String branchMemo;

  ShopBranchModel(
      {
      this.shopDocumentId,
      this.branchDocumentId,
      this.branchName,
      this.branchAddress,
      this.branchMemo});

  factory ShopBranchModel.fromJson(Map<String, dynamic> json) =>
      ShopBranchModel(
          shopDocumentId: json["shopDocumentId"] ?? '',
          branchDocumentId: json["branchDocumentId"] ?? '',
          branchName: json["branchName"] ?? '',
          branchAddress: json["branchAddress"] ?? '',
          branchMemo: json["branchMemo"] ?? '');

  Map<String, dynamic> toJson() => {
        "shopDocumentId": shopDocumentId ?? '',
        "branchDocumentId": branchDocumentId ?? '',
        "branchName": branchName ?? '',
        "branchAddress": branchAddress ?? '',
        "branchMemo": branchMemo ?? ''
      };
}
