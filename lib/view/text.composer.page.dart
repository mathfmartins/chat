import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class TextComposer extends StatefulWidget {

  TextComposer(this._enviarMensagem);
  
  final Function({String text, File imgFile, FirebaseUser user}) _enviarMensagem;

  
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _estaDigitando = false;

  void _resetar() {
      _controller.clear();
      setState(() {
          _estaDigitando = false;
      }); 
  }

  var _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(children: [
        IconButton(
          icon: Icon(Icons.photo_camera), 
          onPressed: () async {
              final File imgFile = 
                       // ignore: deprecated_member_use
                       await ImagePicker.pickImage(source:  ImageSource.camera); 
              if (imgFile == null) return;
              widget._enviarMensagem(imgFile: imgFile);
          }
        ),
        Expanded(child: TextField(
          decoration: InputDecoration.collapsed(hintText: 'Enviar uma Mensagem'),
          controller: _controller,
          onChanged: (text) {
            setState(() {
              _estaDigitando = text.isNotEmpty;
            });
          },
          onSubmitted: (text) {
              widget._enviarMensagem(text: text);
             _resetar();
          },
        )),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: _estaDigitando ? () {
             widget._enviarMensagem(text: _controller.text);
             _resetar();
          } : null
        ),
      ],
    ),
    );
  }
}