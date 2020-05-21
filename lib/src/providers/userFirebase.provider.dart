import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/utils/utils.dart';
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

  Future<DocumentReference> addUserToFirebase(dynamic user, String type) async {
    Firestore fb = Firestore.instance;
    final firebaseUser = user.toJson();
    firebaseUser.addAll({"type": type});
    return fb.collection('Users').add(firebaseUser);
  }

  Future<void> updateUserToFirebase(dynamic user, String docId) async {
    Firestore fb = Firestore.instance;
    final firebaseUser = user.toJson();
    return fb
        .collection('Users')
        .document(docId)
        .setData(firebaseUser, merge: true);
  }

  Future<FirebaseUser> loginUserToFirebase(
      String email, String password) async {
    return (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
  }

  Future<String> changePassword(String newPassword) async {
    try {
      final currentUser = await _auth.currentUser();
      await currentUser.updatePassword(newPassword);
      return 'Contraseña actualizada exitosamente!';
    } catch (e) {
      return 'No se pudo actualizar la contraseña: ${e.toString()}';  
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    return _auth.currentUser();
  }

  Future<DocumentSnapshot> getUserFirebaseByDocID(String documentId) {
    Firestore fb = Firestore.instance;
    return fb.collection('Users').document(documentId).get();
  }

  Future<QuerySnapshot> getUserFirebaseByEmail(String email) {
    Firestore fb = Firestore.instance;
    return fb
        .collection('Users')
        .where('email', isEqualTo: email)
        .getDocuments();
  }

  Container getUserInfo(Map<String, dynamic> user, BuildContext context) {
    final textStyle = TextStyle(fontSize: 18, color: Colors.white);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: user['temperature'] != null,
            child: Text(
              'Temperatura registrada: ${user['temperature']}',
              style: textStyle,
            ),
          ),
          Text(
            'Identificación: ${returnIdTypeCode(user['identificationType'])} ${user['identification']}',
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
