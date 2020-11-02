import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remun_mobile/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:remun_mobile/src/models/user_list_model.dart';

class UserProvider
{
  final String _url = 'http://209.151.144.74/api';
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

    //print(decodedResp);

    if (decodedResp.containsKey('token')) {
      _prefs.token = decodedResp['token'];
      return { 'ok': true, 'token': decodedResp['token'] };
    } else {
      return { 'ok': false, 'message': decodedResp['message'] };
    }
  }

  Future<Map<String, dynamic>> create(dynamic username, dynamic password, dynamic trabajadorId, dynamic rolId) async {

    try {
      final resp = await http.post(
        'http://209.151.144.74/api/users/create-other',
        body: {
          'username': username,
          'password': password,
          'trabajador_id': trabajadorId,
          'rol_id': rolId
        },
        headers: {
          'Authorization': _prefs.token
        },
      );

      Map<String, dynamic> decodedResp = json.decode(resp.body);

      return { 'message': decodedResp['message'] };
    } catch (e) {
      return null;
    }
  }

  Future<List<UserListModel>> get() async {
    final resp = await http.get(
      '$_url/users',
      headers: {
        'Authorization': _prefs.token
      }
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    //print(decodedResp);

    var initialList = decodedResp['users'] as List;
    List<UserListModel> userList = initialList.map((i) => UserListModel.fromJson(i)).toList();

    return userList;
  }
}