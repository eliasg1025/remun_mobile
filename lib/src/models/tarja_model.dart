
class TarjaModel
{
  String fecha;
  String horas;

  TarjaModel({
    this.fecha,
    this.horas
  });

  TarjaModel.fromJson(Map<String, dynamic> json)
  {
    fecha = json['fecha'];
    horas = json['horas'].toString();
  }
}