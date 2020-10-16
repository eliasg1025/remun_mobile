import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remun_mobile/src/bloc/provider.dart';
import 'package:remun_mobile/src/models/employee_model.dart';
import 'package:remun_mobile/src/models/payment_model.dart';
import 'package:remun_mobile/src/providers/employee_provider.dart';
import 'package:remun_mobile/src/utils/utils.dart';

class HomePage extends StatelessWidget
{
  static String name = 'home';

  final employeeProvider = new EmployeeProvider();

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);

    return Scaffold(
      body: Stack(
        children: [
          _crearFondo(context),
          SafeArea(
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
                            'SEPTIEMBRE 2020',
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
                    _crearTarjeta(context),
                    SizedBox(height: 40,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _crearTarjetasIngresosEgresos(context, 1),
                          _crearTarjetasIngresosEgresos(context, 0)
                        ],
                      ),
                    ),
                    SizedBox(height: 50,),
                    Column(
                      children: [
                        Container(
                          child: _crearGrilla(context),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Text('hi'),
      ),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearGrilla(BuildContext context) => GridView.count(
    shrinkWrap: true,
    physics: ClampingScrollPhysics(),
    crossAxisCount: 7,
    padding: const EdgeInsets.all(4),
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    children: _buildCridTielList(context, 30),
  );

  List<Container> _buildCridTielList(BuildContext context, int count) => List.generate(
    count, (i) => Container(child: _crearItemGrilla(context, i),)
  );

  _crearItemGrilla(BuildContext context, int i) {
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
                  Text('Mie 1',
                    style: TextStyle(
                      fontSize: 8.5
                    ),
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '8',
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

  _crearTarjeta(BuildContext context) {
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
                        'S/. 6,354.00',
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

  _crearTarjetasIngresosEgresos(BuildContext context, int ingresos) {

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
                        '${ ingresos == 1 ? '+' : '-' } S/. 2000.00',
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

  _crearPanelUsuario(BuildContext context) {
    return FutureBuilder(
      future: employeeProvider.cargarPagos(),
      builder: (BuildContext context, AsyncSnapshot<EmployeeModel> snapshot) {
        if (snapshot.hasData) {
          final employee = snapshot.data;

          return Container(
            child: Column(
              children: <Widget>[
                Text('${ employee.nombre } ${ employee.apellidoPaterno } ${ employee.apellidoMaterno }'),
                Text('Banco: ${ employee.banco }'),
                Text('Número de Cuenta: ${ employee.numeroCuenta }'),
                SizedBox(height: 40.0,),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: employee.payments.length,
                  itemBuilder: (context, i) => _crearItem(context, employee.payments[i]),
                )
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
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