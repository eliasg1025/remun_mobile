class PaymentDetailModel
{
  int id;
  String concepto;
  double montoHaberDescuento;
  String tipoHaberDescuento;
  int paymentId;

  PaymentDetailModel({
    this.id,
    this.concepto,
    this.montoHaberDescuento,
    this.tipoHaberDescuento,
    this.paymentId
  });

  PaymentDetailModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    concepto = json['concepto'];
    montoHaberDescuento = double.parse(json['monto']);
    tipoHaberDescuento = json['tipo'];
    paymentId = json['pago_id'];
  }
}