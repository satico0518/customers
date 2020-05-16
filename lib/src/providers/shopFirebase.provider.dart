import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/models/shop.model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShopFirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final ShopFirebaseProvider fb = ShopFirebaseProvider._();

  ShopFirebaseProvider._();

  Future<FirebaseUser> signUp(String email, String password) async {
    final AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<DocumentReference> addShopToFirebase(ShopModel shop) async {
    Firestore fb = Firestore.instance;
    final firebaseShop = shop.toJson();
    firebaseShop.addAll({"type": "SHOP"});
    return fb.collection('Shops').add(firebaseShop);
  }

  Future<FirebaseUser> loginShopToFirebase(
      String email, String password) async {
    return (await _auth.signInWithEmailAndPassword(
            email: email, password: password,)).user;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return _auth.currentUser();
  }

  Future<DocumentSnapshot> getShopFirebase(String documentId) {
    Firestore fb = Firestore.instance;
    return fb.collection('Users').document(documentId).get();
  }

  Future<QuerySnapshot> getShopFbByEmail(String email) {
    Firestore fb = Firestore.instance;
    return fb.collection('Users').where('email', isEqualTo: email).getDocuments();
  }
}
