import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remun_mobile/src/bloc/provider.dart';
import 'package:remun_mobile/src/models/employee_model.dart';
import 'package:remun_mobile/src/models/payment_model.dart';
import 'package:remun_mobile/src/models/tarja_model.dart';
import 'package:remun_mobile/src/providers/employee_provider.dart';
import 'package:remun_mobile/src/utils/utils.dart';

class HomePage extends StatelessWidget
{
  static String name = 'home';

  final employeeProvider = new EmployeeProvider();

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);

    employeeProvider.cargarPagos();

    return Scaffold(
      body: Stack(
        children: [
          _crearFondo(context),
          FutureBuilder(
            future: employeeProvider.cargarPagos(),
            builder: (BuildContext context, AsyncSnapshot<EmployeeModel> snapshot) {
              if (snapshot.hasData) {
                final employee = snapshot.data;

                final currentPayment = employee.payments[0];


                return SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 80),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${ obtenerMes(currentPayment.mes) } ${ currentPayment.anio }',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40,),
                          _crearTarjeta(context, currentPayment),
                          SizedBox(height: 40,),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _crearTarjetasIngresosEgresos(context, 1, currentPayment),
                                _crearTarjetasIngresosEgresos(context, 0, currentPayment)
                              ],
                            ),
                          ),
                          SizedBox(height: 50,),
                          Column(
                            children: [
                              Container(
                                child: _crearGrilla(context, employee.tarja),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
          ),
        ],
      ),
      drawer: Drawer(
        child: Text('hi'),
      ),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearGrilla(BuildContext context, List<TarjaModel> tarja) => GridView.count(
    shrinkWrap: true,
    physics: ClampingScrollPhysics(),
    crossAxisCount: 7,
    padding: const EdgeInsets.all(4),
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    children: _buildCridTielList(context, tarja),
  );

  List<Container> _buildCridTielList(BuildContext context, List<TarjaModel> tarja) => List.generate(
    tarja.length, (i) => Container(child: _crearItemGrilla(context, tarja[i]),)
  );

  _crearItemGrilla(BuildContext context, TarjaModel tarjaModel) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.height * 0.10,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0,
                )
              ]
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${ tarjaModel.fecha }',
                    style: TextStyle(
                      fontSize: 8.5
                    ),
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${ tarjaModel.horas }',
                        style: GoogleFonts.muli(
                            textStyle: Theme.of(context).textTheme.display1,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _crearFondo(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue[500], Colors.blue[900]]
          )
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20.0, top: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                Text('PAGOS',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                    )
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _crearTarjeta(BuildContext context, PaymentModel payment) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * .22,
          //color: Colors.white,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0,
                )
              ]
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Anticipo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'S/. ${ payment.monto }',
                        style: GoogleFonts.muli(
                          textStyle: Theme.of(context).textTheme.display1,
                          fontSize: 45,
                          fontWeight: FontWeight.w700,
                          color: Colors.black
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                left: -170,
                top: -170,
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: Color(0xfEF7F7F7),
                ),
              ),
              Positioned(
                left: -160,
                top: -190,
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: Color(0xffF3F3F3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _crearTarjetasIngresosEgresos(BuildContext context, int ingresos, PaymentModel payment) {

    Color colorFondo = ingresos == 1 ? Colors.lightGreen : Colors.redAccent;
    String titulo = ingresos == 1 ? 'Haberes' : 'Descuentos';

    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.77 / 2.2,
          height: MediaQuery.of(context).size.height * .28 / 2.2,
          decoration: BoxDecoration(
              color: colorFondo,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 5.0,
                )
              ]
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${titulo}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${ ingresos == 1 ? '+' : '-' } S/. ${ ingresos == 1 ? payment.haberes : payment.descuentos }',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.zoom_in,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5,),
                        Text('Ver Detalle',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _crearItem(BuildContext context, PaymentModel payment) {
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('SUELDO ${ obtenerMes(payment.mes) } ${ payment.anio }'),
              subtitle: Text('S/. ${ payment.monto.toString() }'),
              contentPadding: EdgeInsets.symmetric(vertical: 20.0),
            ),
          ),
          Column(
            children: <Widget>[
              for(var item in payment.details) Text('${ item.concepto } --- ${ item.montoHaberDescuento } --- ${ item.tipoHaberDescuento }')
            ],
          )
        ],
      )
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon( Icons.exit_to_app ),
      backgroundColor: Colors.blueAccent,
      onPressed: ()=> Navigator.pushNamed(context, 'login'),
    );
  }
}