import 'package:chat/models/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContatosFireBase {

  // ignore: deprecated_member_use
  static List<Contato> contatos = List<Contato>();
  
  static getAllContatos() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('contatos')
        .getDocuments();

    querySnapshot.documents.forEach((element) {
    
    // contatos.add(element as Contato);
    print(element);
    print(element.data);
    });
  }
  
}