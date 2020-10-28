class PaymentDetailModel
{
  int id;
  String concepto;
  double monto;
  int tipo;
  int paymentId;

  PaymentDetailModel({
    this.id,
    this.concepto,
    this.monto,
    this.tipo,
    this.paymentId
  });

  PaymentDetailModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    concepto = json['concepto'];
    monto = json['monto'] + 0.0;
    tipo = json['tipo'];
    paymentId = json['pago_id'];
  }
}