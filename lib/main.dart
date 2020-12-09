import 'package:flutter/material.dart';
import 'package:remun_mobile/src/bloc/provider.dart';
import 'package:remun_mobile/src/pages/home_page.dart';
import 'package:remun_mobile/src/pages/login_page.dart';
import 'package:remun_mobile/src/pages/search_page.dart';
import 'package:remun_mobile/src/pages/users_page.dart';
import 'package:remun_mobile/src/pages/entregas_canastas/search_page.dart' as entregasCanastas;
import 'package:remun_mobile/src/preferencias_usuario/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Remuneraciones Vefrut',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'search': (BuildContext context) => SearchPage(),
          'users': (BuildContext context) => UsersPage(),
          'entregas_canastas.search': (BuildContext context) => entregasCanastas.SearchPage()
        },
      ),
    );
  }
}
