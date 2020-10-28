import 'package:firebase_auth/firebase_auth.dart';
import 'package:swampy/models/user.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  bool initialized = false;

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
        phoneNumber: user.phoneNumber);
  }

  UserModel _userFromEmail(User user, String first, String last) {
    if (user == null) {
      return null;
    }
    return UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoURL: user.photoURL,
        firstName: first,
        lastName: last,
        phoneNumber: null);
  }

  Stream<UserModel> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<UserModel> signInAnonymously() async {
    if (!initialized) {
      Firebase.initializeApp().then((value) => {initialized = true});
    }
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    if (!initialized) {
      Firebase.initializeApp().then((value) => {initialized = true});
    }
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<UserModel> createAccountWithEmailAndPassword(
      String email, String password, String first, String last) async {
    if (!initialized) {
      Firebase.initializeApp().then((value) => {initialized = true});
    }
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromEmail(authResult.user, first, last);
  }

  Future<void> signOut() async {
    if (!initialized) {
      Firebase.initializeApp().then((value) => {initialized = true});
    }
    return _firebaseAuth.signOut();
  }

  UserModel currentUser() {
    return _userFromFirebase(_firebaseAuth.currentUser);
  }
}
