import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  ChatMessage(this.data, this.minhaMensagem);

  final Map<String, dynamic> data;
  final bool minhaMensagem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(children: [
        !minhaMensagem ?
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundImage: NetworkImage(data['foto']),
          ),
        ) : Container(),
        Expanded(child:
         Column(
           crossAxisAlignment: minhaMensagem ? CrossAxisAlignment.end : CrossAxisAlignment.start,
           children: [
           data['imgUrl'] != null ?
              Image.network(data['imgUrl'], width: 250)
              :
              Text(
                data['texto'],
                style: TextStyle(
                  fontSize: 16 
                ),
              ),
          Text(
            data['nome'],
            textAlign: minhaMensagem ? TextAlign.end : TextAlign.start,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500
            ),
          )
        ],)
        ),
        minhaMensagem ?
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundImage: NetworkImage(data['foto']),
          ),
        ) : Container(),
      ],),
    );
  }
}