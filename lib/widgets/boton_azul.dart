import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {

  final Function onPressed;
  final String texto;

  const BotonAzul({
    Key key, 
    @required this.onPressed, 
    this.texto = 'Ingrese'
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      onPressed: this.onPressed,
      child: Container(  
        width: double.infinity,
        height: 55,
        child: Center(  
          child: Text(this.texto, style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
      ),
    );
  }
}