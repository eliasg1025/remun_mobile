class EmployeeListModel
{
  String id;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;

  EmployeeListModel({
    this.id,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno
  });

  factory EmployeeListModel.fromJson(Map<String, dynamic> json)
  {
    return EmployeeListModel(
      id: json['id'],
      nombre: json['nombre'],
      apellidoPaterno: json['apellido_paterno'],
      apellidoMaterno: json['apellido_materno']
    );
  }
}