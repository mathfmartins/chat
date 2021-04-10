import 'dart:io';

import 'package:chat/text.composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {

  void _enviarMensagem({String text, File imgFile}) async {
    Map<String, dynamic> data = {};
    if(imgFile != null) {
      var task = FirebaseStorage.instance.ref().child('fotos').child(
          DateTime.now().microsecondsSinceEpoch.toString()
      ).putFile(imgFile); 
    StorageTaskSnapshot taskSnapshot = 
            await task.onComplete; //dessa forma eu espero a img ser armazenada na storage do firebase
    String url = await taskSnapshot.ref.getDownloadURL(); 
   
    data['imgUrl'] = url;
  }

  if (text != null) {
    data['text'] = text;
  }

  Firestore.instance.collection('mensagens').add(data); 

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá'),
        elevation: 0,
      ),
      body: TextComposer(_enviarMensagem),
    );
  }
}