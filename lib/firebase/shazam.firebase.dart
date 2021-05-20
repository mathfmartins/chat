import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ShazamFireBase {
  static GoogleSignIn googleSignIn = GoogleSignIn();
  static FirebaseUser _usuarioAtual;
  static AuthResult authResult;
  static Future<FirebaseUser> getUser() async {
    if(_usuarioAtual != null) 
        return  _usuarioAtual; // se ele for nulo eu vou fazer o login:
                                              //...
    try {
      final GoogleSignInAccount googleSignInAccount = 
        await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential
          (idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

       authResult = 
        await FirebaseAuth.instance.signInWithCredential(credential);

      final FirebaseUser user = authResult.user;    
    
      return user;  
    } catch (error) {
        return null;
    }
  }
}