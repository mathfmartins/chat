import 'package:chat/models/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class ContatosFireBase {
 final databaseReference = FirebaseDatabase(
      databaseURL: 'https://chat-4a1a8-default-rtdb.firebaseio.com/'
    ).reference();

  // ignore: deprecated_member_use
  static List<Contato> contatos = List<Contato>();
  
   static getAllContatos() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('contatos')
        .getDocuments();
    // ignore: deprecated_member_use
    contatos = List<Contato>();
    querySnapshot.documents.forEach((element) {
    // ignore: deprecated_member_use
        contatos.add(new Contato(nome: element.data['nome'], telefone: element.data['telefone'], email: element.data['email']));
    });
  }

  static addContato(Contato contato) {
    contatos.add(contato);
  }
  
  // atualizarContato() {
  //     databaseReference.child('contatos').once()
  //     // ignore: non_constant_identifier_names
  //     .then((DataSnapshot snapshot) {
  //         if(snapshot.value != null) {
  //           var dbContatos = Map<String, dynamic>.from(snapshot.value);
  //           dbContatos.forEach((key, contato) {
  //               contatos.add(Contato(
  //                 nome: contato['nome'],
  //                 telefone: contato['telefone'],
  //                 email: contato['email']
  //               ));
  //           });
  //         }
  //     });


  }
  
