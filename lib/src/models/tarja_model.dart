
class TarjaModel
{
  String fecha;
  double horas;

  TarjaModel({
    this.fecha,
    this.horas
  });

  TarjaModel.fromJson(Map<String, dynamic> json)
  {
    fecha = json['fecha'];
    horas = double.parse(json['horas'].toString());
  }
}