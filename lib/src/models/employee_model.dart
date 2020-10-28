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

  EmployeeModel({
    this.id,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.payment,
    this.tarja
  });

  factory EmployeeModel.fromJsonMap(Map<String, dynamic> json)
  {
    /*
    var list = json['payment'] as List;
    List<PaymentModel> paymentsList = list.map((i) => PaymentModel.fromJsonMap(i)).toList();*/

    PaymentModel payment = PaymentModel.fromJsonMap(json['payment']);

    var list1 = json['tarja'] as List;
    List<TarjaModel> tarjaList = list1.map((i) => TarjaModel.fromJson(i)).toList();

    return EmployeeModel(
        id: json['id'],
        nombre: json['nombre'],
        apellidoPaterno: json['apellido_paterno'],
        apellidoMaterno: json['apellido_materno'],
        payment: payment,
        tarja: tarjaList
    );
  }
}