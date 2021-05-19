import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseUser _usuarioAtual;
  bool estaCarregando = false;
  // final FirebaseUser user;

 Future<FirebaseUser> _getUser() async {
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

      final AuthResult authResult = 
        await FirebaseAuth.instance.signInWithCredential(credential);

      final FirebaseUser user = authResult.user;    
      Map<String, dynamic> data = {
        "uid": user.uid,
        "nome": user.displayName,
        "foto": user.photoUrl,
        "hora": Timestamp.now() 
      };

      return user;  
    } catch (error) {
        return null;
    }
  }
void entrar(BuildContext context) async {
    final FirebaseUser user = await _getUser();
    if (user == null) {
        // ignore: deprecated_member_use
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Não foi possível fazer o login. Tente novamente.'),
          backgroundColor: Colors.red,
          ),
        );
    }
    else {
        Navigator.of(context).pushNamed('/conversa');
    }
}
class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonTheme(
                height: 60.0,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  // ignore: sdk_version_set_literal
                  onPressed: () => {
                       entrar(context),
                        // ignore: deprecated_member_use
                        _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                        content: Text('Você saiu com sucesso.'),
                        backgroundColor: Colors.green,
                        )
                    ),
                  }
                  ,
                  child: 
                    Text('Entrar com o Google',
                    style: TextStyle(color: Colors.deepPurple)
                  ),
                  color: Colors.white,
                  )
              ),
          ],),
        ),
      ),
    );
  }
}