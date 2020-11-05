import 'package:remun_mobile/src/models/empresa_model.dart';
import 'package:remun_mobile/src/models/payment_type_model.dart';

class PlanillaModel
{
  int mes;
  int anio;
  EmpresaModel empresa;
  PaymentTypeModel tipoPago;

  PlanillaModel({
    this.mes,
    this.anio,
    this.empresa,
    this.tipoPago
  });

  factory PlanillaModel.fromJson(Map<String, dynamic> json) {

    EmpresaModel empresa = EmpresaModel.fromJson(json['empresa']);
    PaymentTypeModel tipoPago = PaymentTypeModel.fromJson(json['tipo_pago']);

    return PlanillaModel(
      mes: json['mes'],
      anio: json['anio'],
      empresa: empresa,
      tipoPago: tipoPago
    );
  }
}