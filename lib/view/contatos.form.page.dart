import 'dart:async';

import 'package:chat/firebase/contatos.firebase.dart';
import 'package:chat/models/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ContatoFormPage extends StatefulWidget {

  @override
  _ContatoFormPageState createState() => _ContatoFormPageState();
}

class _ContatoFormPageState extends State<ContatoFormPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Contato _editedContato = Contato();

  @override
  void initState() {
    // if (contato != null) {
    //  _nameController.text = contato['nome'];
    //     _phoneController.text = contato['telefone'];
    //     _emailController.text = contato['email'];
    // }
  }


  @override
  Widget build(BuildContext context) {
     Map<String, dynamic> contato = ModalRoute.of(context).settings.arguments; 
     var titulo = contato == null ? 'Novo Contato' : contato['nome'];
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text(titulo),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_editedContato.nome.isEmpty || _editedContato.email.isEmpty || _editedContato.telefone.isEmpty) {
              FocusScope.of(context).requestFocus(_nameFocus);

            }
              else if (contato != null) {
                    QuerySnapshot querySnapshot = await Firestore.instance
                          .collection('contatos')
                          .getDocuments();
                    
                      querySnapshot.documents.forEach((element) {
                      if (element.data['telefone'] == contato['telefone'] && element.data['nome'] == contato['nome']) {
                            element.reference.updateData({
                                  'nome': _editedContato.nome,
                                  'telefone': _editedContato.email,
                                  'email': _editedContato.telefone
                              });
                      }
                    });
              }
              else {
             Map<String, dynamic> contatos = {
                  "nome": _editedContato.nome,
                  "email": _editedContato.email,
                  "telefone": _editedContato.telefone
               };
                await Firestore.instance.collection('contatos').add(contatos); 
              }
               Navigator.pop(context);
              FocusScope.of(context).requestFocus(_nameFocus);
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("images/person.png"),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                onTap: (){
                  
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedContato.nome = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContato.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContato.telefone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Descartar Alterações?"),
            content: Text("Se sair as alterações serão perdidas."),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("Sim"),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

}
