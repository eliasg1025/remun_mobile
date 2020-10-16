import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:remun_mobile/src/models/employee_model.dart';

import 'package:remun_mobile/src/preferencias_usuario/preferencias_usuario.dart';

class EmployeeProvider
{
  final String _url = 'http://209.151.144.74/api';
  final _prefs = new PreferenciasUsuario();

  Future<EmployeeModel> cargarPagos() async {
    final url = '$_url/employees';
    final resp = await http.get(
      url,
      headers: {
        'Authorization': _prefs.token
      }
    );

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    final EmployeeModel employee = EmployeeModel.fromJsonMap(decodedData);

    return employee;
  }
}