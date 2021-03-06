import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remun_mobile/src/models/period_model.dart';
import 'package:remun_mobile/src/models/planilla_model.dart';
import 'package:remun_mobile/src/preferencias_usuario/preferencias_usuario.dart';

class PayrollProvider
{
  final String _url = 'http://209.151.144.74/api';
  //final String _url = 'http://10.0.2.2:8000/api';
  final _prefs = new PreferenciasUsuario();

  Future<List<PlanillaModel>> getByTrabajador(String trabajadorId) async {
    final resp = await http.get(
      '$_url/payroll/employee/$trabajadorId',
      headers: {
        'Authorization': _prefs.token
      }
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    var initialList = decodedResp['data'] as List;
    List<PlanillaModel> payrollList = initialList.map((i) => PlanillaModel.fromJson(i)).toList();

    return payrollList;
  }

  Future<List<PeriodModel>> getPeriods() async {
    final resp = await http.get(
      '$_url/payroll/periods',
      headers: {
        'Authorization': _prefs.token
      }
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    var initialList = decodedResp['data'] as List;
    List<PeriodModel> periodsList = initialList.map((i) => PeriodModel.fromJsonMap(i)).toList();

    return periodsList;
  }
}