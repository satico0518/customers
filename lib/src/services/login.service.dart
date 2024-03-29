import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/provider.dart';
import 'package:customers/src/bloc/shop.bloc.dart';
import 'package:customers/src/bloc/user.bloc.dart';
import 'package:customers/src/providers/shopFirebase.provider.dart';
import 'package:flutter/cupertino.dart';

class LoginService {
  static final LoginService _loginService = LoginService._internal();

  factory LoginService() {
    return _loginService;
  }

  LoginService._internal();

  bool isStateOk(QuerySnapshot userSnapshot) {
    final shopData = userSnapshot.documents.first.data;
    if (shopData.keys.any((element) => element == 'maxDate')) {
      final DateTime maxDate = (shopData['maxDate'] as Timestamp).toDate();
      final isBefore = maxDate.isAfter(DateTime.now());
      return isBefore;
    }
    return true;
  }

  Future<bool> isStateOkByBloc(BuildContext context) async {
    final ShopBloc shopBloc = Provider.shopBloc(context);
    final UserBloc userBloc = Provider.of(context);
    if (userBloc.userMaxDate == null) {
      final QuerySnapshot shopQuerySnapshot =
          await ShopFirebaseProvider.fb.getShopFbByEmail(shopBloc.shopEmail);
      final Map<String, dynamic> shop = shopQuerySnapshot.documents.first.data;
      if (shop.keys.any((element) => element == 'maxDate')) {
        final DateTime maxDate = (shop['maxDate'] as Timestamp).toDate();
        final isBefore = maxDate.isAfter(DateTime.now());
        return isBefore;
      }
      return true;
    } else return userBloc.userMaxDate.toDate().isAfter(DateTime.now());
  }
}
