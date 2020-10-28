class PaymentTypeModel
{
  int id;
  String descripcion;

  PaymentTypeModel({
    this.id,
    this.descripcion
  });

  PaymentTypeModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    descripcion = json['descripcion'];
  }
}