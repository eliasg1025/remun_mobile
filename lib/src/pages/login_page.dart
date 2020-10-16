import 'package:flutter/material.dart';
import 'package:remun_mobile/src/bloc/provider.dart';
import 'package:remun_mobile/src/pages/home_page.dart';
import 'package:remun_mobile/src/pages/login_qr_page.dart';
import 'package:remun_mobile/src/providers/users_provider.dart';
import 'package:remun_mobile/src/utils/utils.dart';

class LoginPage extends StatelessWidget
{
  static String name = 'login';

  final userProvider = new UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context)
        ],
      )
    );
  }

  Widget _loginForm(BuildContext context) {

    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 200.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0,
                  )
                ]
            ),
            child: Column(
              children: <Widget>[
                Text('Iniciar Sesión', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 40.0),
                _crearUsername(bloc),
                SizedBox(height: 15.0),
                _crearPassword(bloc),
                SizedBox(height: 15.0),
                _crearBoton(bloc),
                SizedBox(height: 15.0),
              ],
            ),
          ),
          Container(
            width: size.width * 0.85,
            child: RaisedButton(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.scanner),
                    Text('Ingresar con Código QR'),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginQrPage()));
              },
            ),
          ),
          SizedBox(height: 100.0,)
        ],
      ),
    );
  }

  Widget _crearUsername(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(Icons.supervised_user_circle, color: Colors.blueAccent),
              hintText: 'Ej: 12345678',
              labelText: 'Ingrese DNI / CE',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: (value) => bloc.changeEmail(value),
          ),
        );
      }
    );
  }

  Widget _crearPassword(LoginBloc bloc) {

    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.blueAccent),
                labelText: 'Contraseña',
                counterText: snapshot.data,
                errorText: snapshot.error
              ),
              onChanged: (value) => bloc.changePassword(value),
            ),
          );
        }
    );
  }

  Widget _crearBoton(LoginBloc bloc) {

    // formValidStream
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            child: Text('Ingresar'),
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _login(bloc, context): null,
        );
      }
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    print('==================');
    print('Email: ${ bloc.email }');
    print('Password: ${ bloc.password }');
    print('==================');

    Map info = await userProvider.login(bloc.email, bloc.password);

    if ( info['ok'] ) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      mostrarAlerta(context, info['message']);
    }

  }

  Widget _crearFondo(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final background =  Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Colors.blueAccent[400],
            Colors.blueAccent
          ]
        )
      ),
    );

    final circle = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );

    return Stack(
      children: <Widget>[
        background,
        Positioned( child: circle, top: 90.0, left: 30.0 ),
        Positioned( child: circle, top: -40.0, right: -30.0 ),

        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Image(image: AssetImage('assets/logos/grupo-verfrut.png'), height: 100.0,),
              SizedBox(height: 10.0, width: double.infinity,),
              Text('Remuneraciones', style: TextStyle(color: Colors.white, fontSize: 25.0),)
            ],
          ),
        )
      ],
    );
  }
}