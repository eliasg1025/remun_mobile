class EmpresaModel
{
  int id;
  String nombre;
  String nombreCorto;

  EmpresaModel({
    this.id,
    this.nombre,
    this.nombreCorto
  });

  factory EmpresaModel.fromJson(Map<String, dynamic> json) {
    return EmpresaModel(
      id: json['id'],
      nombre: json['nombre'],
      nombreCorto: json['nombre_corto']
    );
  }
}