import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:remun_mobile/src/models/employee_list_model.dart';
import 'package:remun_mobile/src/models/employee_model.dart';

import 'package:remun_mobile/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tuple/tuple.dart';

class EmployeeProvider
{
  final String _url = 'http://209.151.144.74/api';
  //final String _url = 'http://10.0.2.2:8000/api';
  final _prefs = new PreferenciasUsuario();

  Future<EmployeeListModel> show(String trabajadorId) async {
    final url = '$_url/employees/$trabajadorId';

    final resp = await http.get(
      url,
      headers: {
        'Authorization': _prefs.token
      }
    );

    try {
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      final EmployeeListModel employee = EmployeeListModel.fromJson(decodedData);
      return employee;

    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Tuple3<String, bool, EmployeeModel>> cargarPagos(String rut, String periodo, int tipoPagoId, {int empresaId: 0}) async {
    final url = '$_url/employees/$rut/payment?period=$periodo&paymentTypeId=$tipoPagoId&seguro=1&empresaId=$empresaId';
    final resp = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': _prefs.token,
        'Accept': 'application/json'
      }
    );

    try {
      final Map<String, dynamic> decodedData = json.decode(resp.body);

      print(decodedData);

      if (decodedData.containsKey('data')) {
        final EmployeeModel employee = EmployeeModel.fromJsonMap(decodedData['data']);
        return Tuple3<String, bool, EmployeeModel>(decodedData['message'], decodedData['show_message'], employee);
      } else {
        return Tuple3<String, bool, EmployeeModel>(decodedData['message'], null, null);
      }
      
    } catch (e) {
      print(e);
      return Tuple3<String, bool, EmployeeModel>(e.toString(), null, null);
    }
  }

  Future<Tuple2<String, EmployeeModel>> getEntregasCanastas(String rut) async
  {
    final url = '$_url/employees/$rut/entregas-canastas';
    final resp = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': _prefs.token,
        'Accept': 'application/json'
      }
    );

    try {
      final Map<String, dynamic> decodedData = json.decode(resp.body);

      print(decodedData);

      if (decodedData.containsKey('data')) {
        final EmployeeModel employee = EmployeeModel.fromJsonMap(decodedData['data']);
        return Tuple2<String, EmployeeModel>(decodedData['message'], employee);
      } else {
        return Tuple2<String, EmployeeModel>(decodedData['message'], null);
      }
    } catch (e) {
      //print(e);
      return Tuple2<String, EmployeeModel>('Error: ' + e.toString(), null);
    }
  }
}