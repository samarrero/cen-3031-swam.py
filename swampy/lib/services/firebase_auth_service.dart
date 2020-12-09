import 'package:firebase_auth/firebase_auth.dart';
import 'package:swampy/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  FirebaseAuthService({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  UserModel _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoURL: user.photoURL,
        firstName: null,
        lastName: null,
        phoneNumber: null);
  }

  Stream<UserModel> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<UserModel> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final userDoc = await _users.doc(authResult.user.uid).get();
    final data = userDoc.data();
    return UserModel(
      uid: authResult.user.uid,
      email: data['email'],
      firstName: data['first'],
      lastName: data['last'],
    );
  }

  Future<UserModel> createAccountWithEmailAndPassword(
      String email, String password, String first, String last) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    _users.doc(authResult.user.uid).set({
      'first' : '${first[0].toUpperCase()}${first.substring(1)}',
      'last' : '${last[0].toUpperCase()}${last.substring(1)}',
      'email' : email
    }).then((value) => print('Added $first $last')).catchError((error) => print('Error: $error'));
     return UserModel(
      uid: authResult.user.uid,
      email: email,
      firstName: '${first[0].toUpperCase()}${first.substring(1)}',
      lastName: '${last[0].toUpperCase()}${last.substring(1)}',
    );
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  UserModel currentUser() {
    return _userFromFirebase(_firebaseAuth.currentUser);
  }
}
