import 'package:chat/firebase/shazam.firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool estaCarregando = false;

void entrar(BuildContext context) async {
    final FirebaseUser user = await ShazamFireBase.getUser();
    if (user == null) {
        // ignore: deprecated_member_use
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Não foi possível fazer o login. Tente novamente.'),
          backgroundColor: Colors.red,
          ),
        );
    }
    else 
        Navigator.of(context).pushNamed('/contatos', arguments: user);
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
                  },
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