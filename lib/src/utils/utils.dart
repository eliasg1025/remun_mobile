import 'package:flutter/material.dart';

String obtenerMes(int mes) {
  switch (mes) {
    case 1:
      return 'ENERO';
    case 2:
      return 'FEBRERO';
    case 3:
      return 'MARZO';
    case 4:
      return 'ABRIL';
    case 5:
      return 'MAYO';
    case 6:
      return 'JUNIO';
    case 7:
      return 'JULIO';
    case 8:
      return 'AGOSTO';
    case 9:
      return 'SEPTIEMBRE';
    case 10:
      return 'OCTUBRE';
    case 11:
      return 'NOVIEMBRE';
    case 12:
      return 'DICIEMBRE';
  }
}

void mostrarAlerta(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Información incorrecta'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    }
  );
}