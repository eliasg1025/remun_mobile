import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remun_mobile/src/preferencias_usuario/preferencias_usuario.dart';

class UserProvider
{
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'username': email,
      'password': password,
    };

    final resp = await http.post(
      'http://209.151.144.74/api/auth/login',
      body: authData,
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('token')) {
      _prefs.token = decodedResp['token'];
      return { 'ok': true, 'token': decodedResp['token'] };
    } else {
      return { 'ok': false, 'message': decodedResp['message'] };
    }
  }
}