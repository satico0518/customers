import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/src/bloc/user.bloc.dart';
import 'package:customers/src/models/shop-branch.model.dart';
import 'package:customers/src/models/shop.model.dart';
import 'package:customers/src/providers/auth.shared-preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShopFirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final ShopFirebaseProvider fb = ShopFirebaseProvider._();
  final Firestore fbi = Firestore.instance;

  ShopFirebaseProvider._();

  Future<FirebaseUser> signUp(String email, String password) async {
    final AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<DocumentReference> addShopToFirebase(ShopModel shop) async {
    final firebaseShop = shop.toJson();
    firebaseShop.addAll({"type": "SHOP"});
    return fbi.collection('Shops').add(firebaseShop);
  }

  Future<DocumentReference> addShopBranchToFirebase(
      ShopBranchModel branch) async {
    final firebaseShopBranch = branch.toJson();
    return fbi.collection('Branches').add(firebaseShopBranch);
  }

  Future<void> updateShopBranchFirebase(ShopBranchModel branch) async {
    final firebaseShopBranch = branch.toJson();
    return fbi
        .collection('Branches')
        .document(branch.branchDocumentId)
        .setData(firebaseShopBranch, merge: true);
  }

  Future<FirebaseUser> loginShopToFirebase(
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

  Stream<QuerySnapshot> getBranchForms(Timestamp startDate, Timestamp endDate) {
    final _prefs = PreferenceAuth();
    _prefs.initPrefs();
    final branchID = _prefs.currentBranch.branchDocumentId;
    final collection = Firestore.instance.collection('Forms');
    Query query = collection.where('shopBranchDocumentId', isEqualTo: branchID);
    if (startDate != null)
      query = query.where('insertDate', isGreaterThan: startDate);
    if (startDate != null)
      query = query.where('insertDate', isLessThan: endDate);
    
    return query.snapshots();        
  }

  Future<DocumentSnapshot> getShopFirebase(String documentId) {
    return fbi.collection('Users').document(documentId).get();
  }

  Stream<QuerySnapshot> getShopByAuthID(String authID) {
    return fbi
        .collection('Users')
        .where('firebaseId', isEqualTo: authID)
        .snapshots();
  }

  Future<QuerySnapshot> getShopFbByEmail(String email) {
    return fbi
        .collection('Users')
        .where('email', isEqualTo: email)
        .getDocuments();
  }

  Future<QuerySnapshot> getBranchesFbByShopDocId(String shopDocId) {
    return fbi
        .collection('Branches')
        .where('shopDocumentId', isEqualTo: shopDocId)
        .getDocuments();
  }

  updateBranchCapacity(bool isGettingIn, ShopBranchModel branch) {
    fbi
        .collection('Branches')
        .document(branch.branchDocumentId)
        .updateData({'capacity': branch.capacity});
  }

  Future<int> getBranchCapacity(String docID) async {
    final branch = await fbi.collection('Branches').document(docID).get();
    return branch.data['capacity'];
  }

  resetBranchCapacity(ShopBranchModel branch, UserBloc bloc) {
    fbi
        .collection('Branches')
        .document(branch.branchDocumentId)
        .updateData({'capacity': 0});
    final currentBranch = bloc.shopCurrBranch;
    currentBranch.capacity = 0;
    bloc.changeShopCurrBranch(currentBranch);
  }
}
