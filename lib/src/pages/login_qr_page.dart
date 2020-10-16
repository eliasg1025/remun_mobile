import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:remun_mobile/src/providers/users_provider.dart';
import 'package:remun_mobile/src/utils/utils.dart';

class LoginQrPage extends StatefulWidget
{
  @override
  LoginQrPageState createState() => LoginQrPageState();
}


class LoginQrPageState extends State<LoginQrPage>
{
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  final userProvider = new UserProvider();

  @override
  Widget build(BuildContext context) {

    scan();

    return Scaffold(
        appBar: new AppBar(
          title: new Text('Grupo Vefrut Remuneraciones'),
          automaticallyImplyLeading: false,
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: scan,
                    child: const Text('¿No inició el escaneo? Click aquí')
                ),
              )
              ,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(barcode, textAlign: TextAlign.center,),
              )
              ,
            ],
          ),
        )
    );
  }

  _login(String code) async {

  }

  Future scan() async {
    try {
      String barcode = await scanner.scan();

      //MaterialPageRoute(builder: (context) => LoginPage());

      Map info = await userProvider.login(barcode, barcode);

      if ( info['ok'] ) {
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        mostrarAlerta(context, info['message']);
      }

    } on PlatformException catch (e) {
      if (e.code == scanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}