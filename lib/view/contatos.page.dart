import 'dart:io';

import 'package:chat/firebase/contatos.firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}

class ContatosPage extends StatefulWidget {
  @override
  _ContatosPageState createState() => _ContatosPageState();
}

class _ContatosPageState extends State<ContatosPage> {

  // ContactHelper helper = ContactHelper();

  // listaDeContatos<Contact> contacts = listaDeContatos();
   final contat = ContatosFireBase.getAllContatos();

  @override
  void initState() {
    
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.purple,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            // onSelected: _orderlistaDeContatos,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          onPressed: (){
        Navigator.of(context).pushNamed('/contatoForm');

            // _showContactPage();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
      ),
      // body: listaDeContatosView.builder(
      //     padding: EdgeInsets.all(10.0),
      //     itemCount: contacts.length,
      //     itemBuilder: (context, index) {
      //       return _contactCard(context, index);
      //     }
      // ),
    );
  }

  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("images/person.png"),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text(contacts[index].name ?? "",
                      //   style: TextStyle(fontSize: 22.0,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      // Text(contacts[index].email ?? "",
                      //   style: TextStyle(fontSize: 18.0),
                      // ),
                      // Text(contacts[index].phone ?? "",
                      //   style: TextStyle(fontSize: 18.0),
                      // )
                    ],
                  ),
                )
              ],
            ),
        ),
      ),
      onTap: (){
        _mostrarOpcoes(context, index);
      },
    );
  }

  void _mostrarOpcoes(BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        child: Text("Ligar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          // launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        child: Text("Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                          // _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        child: Text("Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          // helper.deleteContact(contacts[index].id);
                          setState(() {
                            // contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }

  // void _showContactPage({Contact contact}) async {
  //   final recContact = await Navigator.push(context,
  //     MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
  //   );
  //   if(recContact != null){
  //     if(contact != null){
  //       await helper.updateContact(recContact);
  //     } else {
  //       await helper.saveContact(recContact);
  //     }
  //     _getAllContacts();
  //   }
  // }

  void _getAllContacts() async {
     QuerySnapshot querySnapshot = await Firestore.instance
        .collection('mensagens')
        .getDocuments();

    querySnapshot.documents.forEach((element) {
    print(element.data);
    print(element.documentID);
    });
    // helper.getAllContacts().then((listaDeContatos){
      setState(() {
        // contacts = listaDeContatos;
      });
    // });
  
  }
  // void _orderlistaDeContatos(OrderOptions result){
  //   switch(result){
  //     case OrderOptions.orderaz:
  //       contacts.sort((a, b) {
  //         return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  //       });
  //       break;
  //     case OrderOptions.orderza:
  //       // contacts.sort((a, b) {
  //         return b.name.toLowerCase().compareTo(a.name.toLowerCase());
  //       });
  //       break;
  //   }
    // setState(() {

    // });
  // }

}
