class PaymentDetailModel
{
  int planillaId;
  String trabajadorId;
  String concepto;
  double monto;
  int tipo;

  PaymentDetailModel({
    this.planillaId,
    this.trabajadorId,
    this.concepto,
    this.monto,
    this.tipo,
  });

  PaymentDetailModel.fromJson(Map<String, dynamic> json)
  {
    planillaId = json['planilla_id'];
    trabajadorId = json['trabajador_id'];
    concepto = json['concepto'];
    monto = double.parse(json['monto']);
    tipo = json['tipo'];
  }
}