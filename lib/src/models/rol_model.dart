class RolModel
{
  int id;
  String descripcion;

  RolModel({
    this.id,
    this.descripcion
  });

  factory RolModel.fromJson(Map<String, dynamic> json)
  {
    return RolModel(
      id: json['id'],
      descripcion: json['descripcion']
    );
  }
}