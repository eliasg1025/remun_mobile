import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:remun_mobile/src/preferencias_usuario/preferencias_usuario.dart';

Widget buildDrawer(BuildContext context) {

  final _prefs = PreferenciasUsuario();

  Map<String, dynamic> decodedToken = JwtDecoder.decode(_prefs.token);

  final rol = decodedToken['rol'];

  return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image(image: AssetImage('assets/logos/grupo-verfrut.png'), height: 100.0,),
            decoration: BoxDecoration(
                color: Colors.blueAccent
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Text('${ decodedToken['trabajador']['nombre'] } ${ decodedToken['trabajador']['apellido_paterno'] }')
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.monetization_on),
                SizedBox(width: 10,),
                Text('Consulta Sueldos'),
              ],
            ),
            onTap: () => Navigator.pushNamed(context, 'search'),
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.playlist_add_check),
                SizedBox(width: 10,),
                Text('Entrega Canastas'),
              ],
            ),
            onTap: () => Navigator.pushNamed(context, 'entregas_canastas.search'),
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.supervised_user_circle),
                SizedBox(width: 10,),
                Text('Gestión Usuarios'),
              ],
            ),
            onTap: () => Navigator.pushNamed(context, 'users'),
            enabled: rol['id'] >= 3,
          ),
          Divider(height: 5, color: Colors.black26,),
          ListTile(
              title: Row(
                children: [
                  Icon(Icons.power_settings_new),
                  SizedBox(width: 10,),
                  Text('Cerrar Sesión'),
                ],
              ),
              onTap: ()=> Navigator.pushNamed(context, 'login')
          ),
        ],
      )
  );
}