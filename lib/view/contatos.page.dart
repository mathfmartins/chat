import 'package:chat/firebase/contatos.firebase.dart';
import 'package:chat/models/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}

class ContatosPage extends StatefulWidget {
  @override
  _ContatosPageState createState() => _ContatosPageState();
}

class _ContatosPageState extends State<ContatosPage> {
    // final database = FirebaseDatabase(
      // databaseURL: 'https://chat-4a1a8-default-rtdb.firebaseio.com/'
    // ).reference();

    // ContactHelper helper = ContactHelper();  
    List<Contato> contatos;
  @override
  // ignore: must_call_super  
  void initState() {
      // getContatos();

  }

  getContatos() async {
    // await ContatosFireBase.getAllContatos();
    // setState(() {
    //       contatos = ContatosFireBase.contatos;
    //   });
  }

  @override
  Widget build(BuildContext context) {
    // var snapshots = Firestore.instance.collection('contatos').where('excluido', isEqualTo: false).snapshots();
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
          onPressed: () async{
            await Navigator.of(context).pushNamed('/contatoForm');

              //  setState(() {
              //         getContatos();
              //   });
              // ContatosFireBase.getAllContatos();
            // setState(() {
            //   contatos = ContatosFireBase.contatos;
            //     // contatos = ContatosFireBase.getAllContatos();
            // });
            // _showContactPage();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('contatos').snapshots(),
        // ignore: missing_return
        // ignore: non_constant_identifier_names
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch(snapshot.connectionState) {
                  case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator(),
                  );
                  default:
                    List<DocumentSnapshot> documents =  snapshot.data.documents;
                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index){
                        return GestureDetector(
                            child: Card(
                              child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 60.0,
                                        height: 60.0,
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
                                            Text(documents[index].data['nome'] ?? "",
                                              style: TextStyle(fontSize: 22.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(documents[index].data['email'] ?? "",
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                            Text(documents[index].data['telefone'] ?? "",
                                              style: TextStyle(fontSize: 18.0),
                                            )
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
                      }, 
                    );
            }
            // return _contactCard(context, snapshot)
        },
      )
    );
  }

  // Widget _contactCard(BuildContext context, int index){
  //   return GestureDetector(
  //     child: Card(
  //       child: Padding(
  //           padding: EdgeInsets.all(10.0),
  //           child: Row(
  //             children: <Widget>[
  //               Container(
  //                 width: 80.0,
  //                 height: 80.0,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   image: DecorationImage(
  //                       image: AssetImage("images/person.png"),
  //                       fit: BoxFit.cover
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(left: 10.0),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: <Widget>[
  //                     Text(contatos[index].nome ?? "",
  //                       style: TextStyle(fontSize: 22.0,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     Text(contatos[index].email ?? "",
  //                       style: TextStyle(fontSize: 18.0),
  //                     ),
  //                     Text(contatos[index].telefone?? "",
  //                       style: TextStyle(fontSize: 18.0),
  //                     )
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //       ),
  //     ),
  //     onTap: (){
  //       _mostrarOpcoes(context, index);
  //     },
  //   );
  // }

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
                          launch("tel:${contatos[index].telefone}");
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
                          // _showContactPage(contact: contatos[index]);
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
                          // helper.deleteContact(contatos[index].id);
                          setState(() {
                            // contatos.removeAt(index);
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
  //     _getAllcontatos();
  //   }
  // }

  // void _getAllcontatos() async {
  //   helper.getAllcontatos().then((listaDeContatos){
  //     setState(() {
  //       // contatos = listaDeContatos;
  //     });
  //   });
  
  }
  // void _orderlistaDeContatos(OrderOptions result){
  //   switch(result){
  //     case OrderOptions.orderaz:
  //       contatos.sort((a, b) {
  //         return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  //       });
  //       break;
  //     case OrderOptions.orderza:
  //       // contatos.sort((a, b) {
  //         return b.name.toLowerCase().compareTo(a.name.toLowerCase());
  //       });
  //       break;
  //   }
    // setState(() {

    // });
  // }

// }
