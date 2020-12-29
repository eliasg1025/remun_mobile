import 'package:remun_mobile/src/models/empresa_model.dart';
import 'package:remun_mobile/src/models/payment_detail_model.dart';
import 'package:remun_mobile/src/models/payment_type_model.dart';

class PaymentModel
{
  int id;
  int anio;
  int mes;
  double monto;
  double haberes;
  double descuentos;
  String banco;
  String numeroCuenta;
  DateTime fechaIngreso;
  int companyId;
  String employeeId;
  int zonaId;
  List<PaymentDetailModel> details;
  PaymentTypeModel paymentType;
  EmpresaModel empresa;

  PaymentModel({
    this.id,
    this.anio,
    this.mes,
    this.monto,
    this.banco,
    this.numeroCuenta,
    this.haberes,
    this.descuentos,
    this.fechaIngreso,
    this.companyId,
    this.employeeId,
    this.zonaId,
    this.details,
    this.paymentType,
    this.empresa,
  });

  factory PaymentModel.fromJsonMap(Map<String, dynamic> json)
  {
    var list = json['details'] as List;
    List<PaymentDetailModel> paymentsDetailList = list.map((i) => PaymentDetailModel.fromJson(i)).toList();
    
    PaymentTypeModel paymentType = PaymentTypeModel.fromJson(json['type_payment']);

    EmpresaModel empresa = EmpresaModel.fromJson(json['company']);
    
    return PaymentModel(
      id: json['id'],
      anio: json['anio'],
      mes: json['mes'],
      banco: json['banco'],
      numeroCuenta: json['numero_cuenta'],
      monto: double.parse(json['monto']),
      fechaIngreso: DateTime.parse(json['fecha_ingreso']),
      companyId: json['empresa_id'],
      employeeId: json['trabajador_id'],
      zonaId: json['zona_id'],
      details: paymentsDetailList,
      paymentType: paymentType,
      empresa: empresa,
    );
  }

  String hasAsignacionFamiliar()
  {
    var asig = this.details.firstWhere((element) => element.concepto == '150 ASIG. FAMILIAR', orElse: () => null);

    return asig == null ? 'NO TIENE' : 'SI TIENE (S/ .${ asig.monto })';
  }
}