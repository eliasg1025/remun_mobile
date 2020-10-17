import 'package:remun_mobile/src/models/payment_model.dart';
import 'package:remun_mobile/src/models/tarja_model.dart';

class EmployeeModel
{
  String id;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String banco;
  String numeroCuenta;
  List<PaymentModel> payments;
  List<TarjaModel> tarja;

  EmployeeModel({
    this.id,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.banco,
    this.numeroCuenta,
    this.payments,
    this.tarja
  });

  factory EmployeeModel.fromJsonMap(Map<String, dynamic> json)
  {
    var list = json['payments'] as List;
    List<PaymentModel> paymentsList = list.map((i) => PaymentModel.fromJsonMap(i)).toList();

    var list1 = json['tarja'] as List;
    List<TarjaModel> tarjaList = list1.map((i) => TarjaModel.fromJson(i)).toList();

    return EmployeeModel(
        id: json['id'],
        nombre: json['nombre'],
        apellidoPaterno: json['apellido_paterno'],
        apellidoMaterno: json['apellido_materno'],
        banco: json['banco'],
        numeroCuenta: json['numero_cuenta'],
        payments: paymentsList,
        tarja: tarjaList
    );
  }
}