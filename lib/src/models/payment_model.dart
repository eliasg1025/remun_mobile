import 'package:remun_mobile/src/models/payment_detail_model.dart';

class PaymentModel
{
  int id;
  int anio;
  int mes;
  double monto;
  double haberes;
  double descuentos;
  int companyId;
  String employeeId;
  int zonaId;
  List<PaymentDetailModel> details;

  PaymentModel({
    this.id,
    this.anio,
    this.mes,
    this.monto,
    this.haberes,
    this.descuentos,
    this.companyId,
    this.employeeId,
    this.zonaId,
    this.details
  });

  factory PaymentModel.fromJsonMap(Map<String, dynamic> json)
  {
    var list = json['details'] as List;
    List<PaymentDetailModel> paymentsDetailList = list.map((i) => PaymentDetailModel.fromJson(i)).toList();
    return PaymentModel(
      id: json['id'],
      anio: json['anio'],
      mes: json['mes'],
      monto: double.parse(json['monto']),
      haberes: double.parse(json['haberes']),
      descuentos: double.parse(json['descuentos']),
      companyId: json['empresa_id'],
      employeeId: json['trabajador_id'],
      zonaId: json['zona_id'],
      details: paymentsDetailList
    );
  }
}