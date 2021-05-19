import 'package:chat/chat.page.dart';
import 'package:chat/login.page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());

  // QuerySnapshot querySnapshot = await Firestore.instance
  //       .collection('mensagens')
  //       .getDocuments();

  //   querySnapshot.documents.forEach((element) {
  //   print(element.data);
  //   print(element.documentID);

  //   element.reference.updateData({'lido': true}); 
  // });

  // DocumentSnapshot element = await Firestore.instance
  //         .collection('mensagens')
  //         .document('qyTnRFr1iM47HC8cJcMO').get();
          
  // print(element.documentID);
  // print(element.data);
  // element.reference.updateData({'from': 'Mary Streep'});

  // //Atualização sempre quando o documento mudar!
  // Firestore.instance.collection('mensagens').snapshots().listen((event) {
  //     event.documents.forEach((e) {
  //         print(e.data);
  //     });
  // });

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shazam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        iconTheme: IconThemeData(color: Colors.orange[400])
      ),
      routes: {
        '/': (context) => LoginPage(),
        // '/': (context) => ContatosPage(),
        '/chat': (context) => ChatPage(),
      },
      // home: ChatPage(),
    );
  }
}