import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drone_assist/src/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AuthService {
  Future<AppUser> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    // Checking if email and name is null
    assert(user!.email != null);
    assert(user!.displayName != null);
    assert(user!.photoURL != null);

    Map<String, dynamic> _tempUser = {};
    final User? currentUser = _auth.currentUser!;
    assert(user!.uid == currentUser!.uid);

    await _firestore
        .collection('/users')
        .doc(currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        _tempUser = snapshot.data as Map<String, dynamic>;
      } else {
        print("Signin: User Data doesn't exist in firestore!");
        _tempUser = {
          'name': user!.displayName,
          'uid': user.uid,
          'email': user.email,
          'profileImageUrl': user.photoURL,
          'about': "",
          'batch': "",
          'contact': "",
          'quote': "What quote describes you ?",
          'cvLink': "",
          'fbId': "",
          'instaId': "",
          'interests': "",
          'branch': "",
          'isAdmin': false,
          'isMember': true,
          'linkedinId': "",
          'position': "N/A",
        };
        _firestore.collection('/users').doc(user.uid).set(_tempUser);
      }
    });
    // Only taking the first part of the name, i.e., First Name
    // if (name.contains(" ")) {
    //   name = name.substring(0, name.indexOf(" "));
    // }

    assert(!user!.isAnonymous);
    assert(await user!.getIdToken() != null);

    return AppUser.fromMap(_tempUser);
  }

  Future<AppUser> getCurrentUser() async {
    Map<String, dynamic> _tempUser = {};
    final User currentUser = _auth.currentUser!;
    bool isFound = false;
    if (currentUser == null) {
      return AppUser();
    } else {
      await _firestore
          .collection('/users')
          .doc(currentUser.uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          _tempUser = snapshot.data as Map<String, dynamic>;
          isFound = true;
        } else {
          print("User Data doesn't exist in firestore!");
          isFound = false;
        }
      });
    }
    return isFound ? AppUser.fromMap(_tempUser) : AppUser();
  }

  Future signOutGoogle() async {
    await googleSignIn.signOut();
    await _auth.signOut();

    print("User Sign Out");
  }
}
