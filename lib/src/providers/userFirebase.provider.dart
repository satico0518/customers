import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserFirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final UserFirebaseProvider fb = UserFirebaseProvider._();

  UserFirebaseProvider._();

  Future<FirebaseUser> signUp(String email, String password) async {
    final AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<DocumentReference> addUserToFirebase(UserModel user) async {
    Firestore fb = Firestore.instance;
    final firebaseUser = user.toJson();
    firebaseUser.addAll({"type": "CUSTOMER"});
    return fb.collection('Users').add(firebaseUser);
  }

  Future<FirebaseUser> loginUserToFirebase(
      String email, String password) async {
    return (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return _auth.currentUser();
  }

  Future<DocumentSnapshot> getUserFirebaseByDocID(String documentId) {
    Firestore fb = Firestore.instance;
    return fb.collection('Users').document(documentId).get();
  }

  Future<QuerySnapshot> getUserFirebaseByemail(String email) {
    Firestore fb = Firestore.instance;
    return fb
        .collection('Users')
        .where('email', isEqualTo: email)
        .getDocuments();
  }

  Container getUserInfo(Map<String, dynamic> user, BuildContext context) {
    final textStyle = TextStyle(fontSize: 18, color: Colors.white);
    _returnIdTypeCode(String text) {
      String code = 'CC';
      switch (text) {
        case 'Cedula Ciudadanía':
          code = 'CC';
          break;
        case 'NIT':
          code = 'NIT';
          break;
        case 'Cedula Extrangería':
          code = 'CE';
          break;
        case 'Registro Civil':
          code = 'RC';
          break;
        case 'Otro':
          code = 'Otro';
          break;
        default:
          code = 'N/A';
      }
      return code;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Identificación: ${_returnIdTypeCode(user['identificationType'])} ${user['identification']}',
            style: textStyle,
          ),
          Text(
            'Nombre: ${user['name']} ${user['lastName']}',
            style: textStyle,
          ),
          Text(
            'Teléfono: ${user['contact']}',
            style: textStyle,
          ),
          Text(
            'Email: ${user['email']}',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
