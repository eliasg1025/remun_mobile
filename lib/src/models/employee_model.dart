import 'package:remun_mobile/src/models/entrega_canatas_model.dart';
import 'package:remun_mobile/src/models/payment_model.dart';
import 'package:remun_mobile/src/models/tarja_model.dart';

class EmployeeModel
{
  String id;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  PaymentModel payment;
  List<TarjaModel> tarja;
  EntregaCanastaModel entregaCanasta;

  EmployeeModel({
    this.id,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.payment,
    this.tarja,
    this.entregaCanasta,
  });

  factory EmployeeModel.fromJsonMap(Map<String, dynamic> json)
  {
    PaymentModel payment = json.containsKey('payment')
      ? PaymentModel.fromJsonMap(json['payment'])
      : null;
    
    List<TarjaModel> tarjaList = [];
    if (json.containsKey('tarja')) {
      var list1 = json['tarja'] as List;
      tarjaList = list1.map((i) => TarjaModel.fromJson(i)).toList();
    }

    EntregaCanastaModel entregaCanasta = json.containsKey('entrega_canasta')
      ? ( json['entrega_canasta'] != null ? EntregaCanastaModel.fromJsonMap(json['entrega_canasta']) : null)
      : null;

    return EmployeeModel(
        id: json['id'],
        nombre: json['nombre'],
        apellidoPaterno: json['apellido_paterno'],
        apellidoMaterno: json['apellido_materno'],
        payment: payment,
        tarja: tarjaList,
        entregaCanasta: entregaCanasta
    );
  }
}