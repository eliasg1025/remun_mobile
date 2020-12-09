import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remun_mobile/src/preferencias_usuario/preferencias_usuario.dart';
class EntregaCanastaProvider
{
  final String _url = 'http://209.151.144.74/api';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> create(String employeeId) async {

    try {
      final resp = await http.post(
        '$_url/entregas-canastas',
        body: {
          'employee_id': employeeId,
        },
        headers: {
          'Authorization': _prefs.token,
          'Accept': 'application/json'
        },
      );

      Map<String, dynamic> decodedResp = json.decode(resp.body);

      return { 'message': decodedResp['message'] };
    } catch (e) {
      return { 'message': 'Error ${e.toString()}' };
    }
  }
}