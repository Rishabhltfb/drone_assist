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

    return getUserFromDb(user);
  }

  Future<AppUser> getUserFromDb(User? user) async {
    Map<String, dynamic> _tempUser = {};
    final User? currentUser = _auth.currentUser!;
    assert(user!.uid == currentUser!.uid);
    print("Current User is: \t\t ${currentUser!.uid}");
    await _firestore
        .collection('/users')
        .doc(currentUser.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        _tempUser = snapshot.data() as Map<String, dynamic>;
      } else {
        print("Signin: User Data doesn't exist in firestore!");
        AppUser tempUser = new AppUser();
        tempUser.name = user!.displayName!;
        tempUser.email = user.email!;
        tempUser.photoURL = user.photoURL!;
        _tempUser = {
          'uid': user.uid,
          'name': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
          "checklistsId": [],
        };
        _firestore.collection('/users').doc(user.uid).set(_tempUser);
      }
    }).onError((error, stackTrace) {
      print("Error while Checking user doc: $error ");
    });

    assert(!user!.isAnonymous);

    return AppUser.fromMap(_tempUser);
  }


  Future<AppUser> getCurrentUser() async {
    Map<String, dynamic> _tempUser = {};
    final User currentUser = _auth.currentUser!;
    bool isFound = false;
    print("Inside get Current User");
    if (currentUser.displayName!.isEmpty) {
      return AppUser();
    } else {
      await _firestore
          .collection('/users')
          .doc(currentUser.uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          _tempUser = snapshot.data() as Map<String, dynamic>;
          isFound = true;
        } else {
          print("User Data doesn't exist in firestore!");
          isFound = false;
        }
      }).onError((error, stackTrace) {
        print("Error while fetching Current User: $error");
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
