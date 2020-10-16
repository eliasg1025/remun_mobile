import 'package:remun_mobile/src/models/payment_model.dart';

class EmployeeModel
{
  String id;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String banco;
  String numeroCuenta;
  List<PaymentModel> payments;

  EmployeeModel({
    this.id,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.banco,
    this.numeroCuenta,
    this.payments
  });

  factory EmployeeModel.fromJsonMap(Map<String, dynamic> json)
  {
    var list = json['payments'] as List;
    List<PaymentModel> paymentsList = list.map((i) => PaymentModel.fromJsonMap(i)).toList();

    return EmployeeModel(
        id: json['id'],
        nombre: json['nombre'],
        apellidoPaterno: json['apellido_paterno'],
        apellidoMaterno: json['apellido_materno'],
        banco: json['banco'],
        numeroCuenta: json['numero_cuenta'],
        payments: paymentsList,
    );
  }
}