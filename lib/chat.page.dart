import 'dart:io';

import 'package:chat/chat.message.dart';
import 'package:chat/firebase/firebase.shazam.dart';
import 'package:chat/text.composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  // final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseUser _usuarioAtual;
  bool estaCarregando = false;

  void initState() {
      super.initState();

      FirebaseAuth.instance.onAuthStateChanged.listen((user) {
        setState(() {
                  _usuarioAtual = user;
        });
      _usuarioAtual = user;

   });  

  }

  void _enviarMensagem({String text, File imgFile, user: FirebaseUser}) async {
  FirebaseUser user = ModalRoute.of(context).settings.arguments; 

    // final FirebaseUser user = await _getUser();
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
      "nome": user.displayName,
      "foto": user.photoUrl,
      "hora": Timestamp.now() 
    };

    if(imgFile != null) {
      var task = FirebaseStorage.instance.ref().child('fotos').child(
          DateTime.now().microsecondsSinceEpoch.toString()
      ).putFile(imgFile); 

    setState(() {
        estaCarregando = true;
    });
    StorageTaskSnapshot taskSnapshot = 
            await task.onComplete; //dessa forma eu espero assim que a imagem for armazenada 
                                  //no storage do firebase, eu pego sua referencia
    String url = await taskSnapshot.ref.getDownloadURL(); 
   
    data['imgUrl'] = url;

     setState(() {
        estaCarregando = false;
    });
  }

  if (text != null) data['texto'] = text;
  

  Firestore.instance.collection('mensagens').add(data); 

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _usuarioAtual != null ? 'Olá, ${_usuarioAtual.displayName}' : 'Shazam'),
          centerTitle: true,
        elevation: 0,
        actions: [
          _usuarioAtual != null ? IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
                  FireBaseShazam.googleSignIn.signOut();
                   FirebaseAuth.instance.signOut();
                   Navigator.of(context).pop();
                // googleSignIn.signOut();
                // ignore: deprecated_member_use
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                    content: Text('Você saiu com sucesso.'),
                    backgroundColor: Colors.green,
                ));
            },
          ) : Container()
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              //sempre que houver alguma modificação na collection 'mensagens', a stream será recarregada
              stream: Firestore.instance.collection('mensagens').orderBy('hora').snapshots(),
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
                          title: ChatMessage(documents[index].data, //true, suponde que todas as mensagens são minhas
                                            documents[index].data['uid'] == _usuarioAtual?.uid)  
                        );
                      }, 
                    );
                }
              },
            ),
          ),
          estaCarregando ? LinearProgressIndicator() : Container(),
          TextComposer(_enviarMensagem),
        ],
      ),
    );
  }
}