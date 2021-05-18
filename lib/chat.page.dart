import 'dart:io';

import 'package:chat/text.composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseUser _usuarioAtual;

  void initState() {
      super.initState();

      FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      _usuarioAtual = user;

   });  

  }

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
      return user;  
    } catch (error) {
        return null;
    }
  }

  void _enviarMensagem({String text, File imgFile}) async {
    final FirebaseUser user = await _getUser();
    if (user == null) {
        // ignore: deprecated_member_use
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Não foi possível fazer o login. Tente novamente.'),
          backgroundColor: Colors.red,
          ),
        );
    }
    Map<String, dynamic> data = {
      "uid": user.uid,
      "Nome": user.displayName,
      "foto": user.photoUrl
    };

    if(imgFile != null) {
      var task = FirebaseStorage.instance.ref().child('fotos').child(
          DateTime.now().microsecondsSinceEpoch.toString()
      ).putFile(imgFile); 

    StorageTaskSnapshot taskSnapshot = 
            await task.onComplete; //dessa forma eu espero assim que a imagem for armazenada 
                                  //no storage do firebase, eu pego sua referencia
    String url = await taskSnapshot.ref.getDownloadURL(); 
   
    data['imgUrl'] = url;
  }

  if (text != null) data['texto'] = text;
  

  Firestore.instance.collection('mensagens').add(data); 

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Shazam'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              //sempre que houver alguma modificação na collection 'mensagens', a stream será recarregada
              stream: Firestore.instance.collection('mensagens').snapshots(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator(),
                  );
                  default:
                    List<DocumentSnapshot> documents =  snapshot.data.documents.reversed.toList();
                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index){
                        return ListTile(
                          title: Text(documents[index].data['texto']),
                        );
                      }, 
                    );
                }
              },
            ),
          ),
          TextComposer(_enviarMensagem),
        ],
      ),
    );
  }
}