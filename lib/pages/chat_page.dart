import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;

  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1, 
        title: Column(  
          children: [

            CircleAvatar( 
              child: Text('Te', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),

            SizedBox(height: 3),

            Text('Melissa FLores', style: TextStyle(color: Colors.black87, fontSize: 12))

          ],
        ),
        
      ),

      body: Container(
        child: Column(  
          children: [

            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              ),
            ),

            Divider(height: 1),

            //TODO:Caja de texto
            Container(
              color: Colors.white,
              height: 70,
              child: _inputChat(),
            ),

          ],
        ),
      ),
   );
  }

  Widget _inputChat() {

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [

            Flexible(
              child: TextField(
                controller: this._textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto){
                  setState(() {
                    if(texto.trim().length > 0){
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(  
                  hintText: 'Enviar mensaje'
                ),
                focusNode: this._focusNode,
              ),
            ),

            //Boton de enviar
            Container(  
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                    ? CupertinoButton(
                      child: Text('Enviar'), 
                      onPressed: _estaEscribiendo
                                ? () => _handleSubmit(_textController.text.trim())
                                : null
                    )
                    : Container(  
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(  
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed: _estaEscribiendo
                                      ? () => _handleSubmit(_textController.text.trim())
                                      : null
                        ),
                      ),
                    )
            )

          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {

    if (texto.length == 0) return;

    print(texto);
    this._textController.clear();
    this._focusNode.requestFocus();

    final newMessage = new ChatMessage(
      texto: texto, 
      uid: '123',
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200)
      ),
    );

    this._messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      this._estaEscribiendo = false;
    });
  }

  @override
  void dispose() {
    // TODO: off del socket

    for( ChatMessage message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }
}


    

  
