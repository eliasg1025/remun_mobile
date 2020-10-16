import 'package:remun_mobile/src/models/payment_detail_model.dart';

class PaymentModel
{
  int id;
  int anio;
  int mes;
  double monto;
  int companyId;
  String employeeId;
  int zonaId;
  List<PaymentDetailModel> details;

  PaymentModel({
    this.id,
    this.anio,
    this.mes,
    this.monto,
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
      companyId: json['company_id'],
      employeeId: json['employee_id'],
      zonaId: json['zona_id'],
      details: paymentsDetailList
    );
  }
}