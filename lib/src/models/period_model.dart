class PeriodModel
{
  int mes;
  int anio;
  int cantidadPlanillas;

  PeriodModel({
    this.mes,
    this.anio,
    this.cantidadPlanillas
  });

  factory PeriodModel.fromJsonMap(Map<String, dynamic> json)
  {
    return PeriodModel(
      mes: json['mes'],
      anio: json['anio'],
      cantidadPlanillas: json['cantidad_planillas']
    );
  }
}