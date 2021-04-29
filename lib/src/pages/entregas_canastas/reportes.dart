import 'package:flutter/material.dart';
import 'package:remun_mobile/src/providers/entrega_canasta_provider.dart';

class ReportesView extends StatefulWidget
{
  @override
  _ReportesViewState createState() => _ReportesViewState();
}

class _ReportesViewState extends State<ReportesView>
{
  @override
  initState() {
    super.initState();
  }

  final entregasCanastasProvider = new EntregaCanastaProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder (
        future: entregasCanastasProvider.getReporte(),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              final columnas = new List<String>.from(snapshot.data['columnas']);
              final filas = new List<dynamic>.from(snapshot.data['filas']);

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildTablaResumen(context, columnas, filas),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
        }
    );
  }

  Widget _buildTablaResumen(BuildContext context, List<String> columnas, List<dynamic> filas) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          columns: columnas.map((columna) => DataColumn(
              label: Text(columna)
          )).toList(),
          rows: filas.map((fila) {
            List<dynamic> f = new List<dynamic>.from(fila);
            return DataRow(
                cells: f.map((celda) {
                  return DataCell(Text(celda.toString()));
                }).toList()
            );
          }).toList()
      ),
    );
  }
}