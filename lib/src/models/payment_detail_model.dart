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
    montoHaberDescuento = double.parse(json['monto_haber_descuento']);
    tipoHaberDescuento = json['tipo_haber_descuento'];
    paymentId = json['payment_id'];
  }
}