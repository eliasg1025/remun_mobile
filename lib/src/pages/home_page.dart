import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remun_mobile/src/bloc/provider.dart';
import 'package:remun_mobile/src/models/employee_model.dart';
import 'package:remun_mobile/src/models/payment_detail_model.dart';
import 'package:remun_mobile/src/models/payment_model.dart';
import 'package:remun_mobile/src/models/planilla_model.dart';
import 'package:remun_mobile/src/models/tarja_model.dart';
import 'package:remun_mobile/src/providers/employee_provider.dart';
import 'package:remun_mobile/src/providers/payroll_provider.dart';
import 'package:remun_mobile/src/utils/utils.dart';
import 'package:remun_mobile/src/widgets/alert_box.dart';
import 'package:remun_mobile/src/widgets/drawer.dart';
import 'package:tuple/tuple.dart';


class HomePage extends StatefulWidget
{
  final Tuple3<String, bool, EmployeeModel> employee;
  HomePage({
    this.employee
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
{
  static String name = 'home';

  final employeeProvider = new EmployeeProvider();
  final payrollProvider = new PayrollProvider();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Consulta Sueldos'),
        backgroundColor: Colors.blueAccent[400],
        shadowColor: Colors.white10,
      ),
      body: Stack(
        children: [
          _crearFondo(context),
          _crearMainComponent(context, widget.employee.item3)
        ],
      ),
      drawer: buildDrawer(context),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearMainComponent(BuildContext context, EmployeeModel employee) {

    final currentPayment = employee.payment;

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              _buildHeader(context, currentPayment),
              widget.employee.item2 ? buildAlertBox(context, 'Observación', widget.employee.item1) : SizedBox(height: 0),
              SizedBox(height: 20,),
              _crearTarjeta(context, currentPayment),
              SizedBox(height: 20,),
              _crearTarjetaInfoTrabajador(context, employee),
              SizedBox(height: 20,),
              Column(
                children: [
                  Container(
                    child: _crearGrilla(context, employee.tarja),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _crearTarjetasIngresosEgresos(context, 1, currentPayment),
                    _crearTarjetasIngresosEgresos(context, 0, currentPayment)
                  ],
                ),
              ),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PaymentModel currentPayment) => Container(
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
        //SizedBox(width: 5,),
        Expanded(
          child: Container(
            child: FlatButton(
              onPressed: () => _settingModalCalendar(context),
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7),
                    bottomLeft: Radius.circular(7),
                    bottomRight: Radius.circular(7)
                  ),
                  boxShadow: [
                    widget.employee.item2 ? BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ) : BoxShadow()
                  ],
                ),
                child: Icon(Icons.calendar_today,
                  color: Colors.blueAccent,
                  size: 26,
                ),
              ) 
            ),
          ) 
        ),
      ],
    ),
  );

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
                      fontSize: 7
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
                SizedBox(
                  width: 50.0,
                  /*
                  child: RaisedButton(
                      color: Colors.white,
                      onPressed: () => print('hi'),
                      child: Icon(
                        Icons.menu,
                        color: Colors.blueAccent,
                      ),
                  ),*/
                ),
                SizedBox(
                  width: 50.0,
                  /*
                  child: RaisedButton(
                    color: Colors.white,
                    onPressed: () => print('hi'),
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.blueAccent,
                    ),
                  ),
                   */
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _crearTarjeta(BuildContext context, PaymentModel payment) {

    final formatCurrency = new NumberFormat("#,##0.00", "en_US");

    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * .22,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black,
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
                    '${ payment.paymentType.descripcion }',
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
                        'S/. ${ formatCurrency.format(payment.monto) }',
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
            ],
          ),
        ),
      ),
    );
  }

  _crearTarjetaInfoTrabajador(BuildContext context, EmployeeModel employee) {

    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * .31,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0)
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Text('DATOS PERSONALES',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 15,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('DNI:', style: TextStyle(fontWeight: FontWeight.w500),),
                                  SizedBox(height: 5,),
                                  Text('Nombre:', style: TextStyle(fontWeight: FontWeight.w500),),
                                  SizedBox(height: 5,),
                                  Text('Empresa:', style: TextStyle(fontWeight: FontWeight.w500),),
                                  SizedBox(height: 5,),
                                  Text('Fecha Ingreso:', style: TextStyle(fontWeight: FontWeight.w500),),
                                  SizedBox(height: 5,),
                                  Text('Banco:', style: TextStyle(fontWeight: FontWeight.w500),),
                                  SizedBox(height: 5,),
                                  Text('N° Cuenta:', style: TextStyle(fontWeight: FontWeight.w500),),
                                  SizedBox(height: 5,),
                                  Text('Asig. Familiar:', style: TextStyle(fontWeight: FontWeight.w500),),
                                ],
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${ employee.id }'),
                                  SizedBox(height: 5,),
                                  Text('${ employee.nombre } ${ employee.apellidoPaterno } ${ employee.apellidoMaterno }'),
                                  SizedBox(height: 5,),
                                  Text('${ employee.payment.empresa.nombreCorto }',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text('${ formatDate(employee.payment.fechaIngreso) }'),
                                  SizedBox(height: 5,),
                                  Text('${ employee.payment.banco }'),
                                  SizedBox(height: 5,),
                                  Text('${ employee.payment.numeroCuenta }'),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      employee.payment.hasAsignacionFamiliar() == 'NO TIENE' ?
                                      Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ) :
                                      Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      Text('${ employee.payment.hasAsignacionFamiliar() }',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
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
          height: MediaQuery.of(context).size.height * .20 / 2.2,
          child: RaisedButton(
            onPressed: () => _settingModalBottomSheet(context, ingresos, payment),
            color: colorFondo,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$titulo',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    //SizedBox(height: 10,),
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
      ),
    );

  }

  _settingModalBottomSheet(BuildContext context, int esIngreso, PaymentModel paymentModel) {

    List<PaymentDetailModel> details = paymentModel.details.where((e) => e.tipo == esIngreso).toList();
    String tipoDetalle = esIngreso == 1 ? 'Haberes' : 'Descuentos';
    double totalDetalle = details.fold(0, (value, element) => value + element.monto);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.monetization_on,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 10,),
                        Icon(esIngreso == 1 ? Icons.add : Icons.remove,
                          color: esIngreso == 1 ? Colors.green : Colors.red,
                        ),
                        Text(tipoDetalle)
                      ],
                    ),
                    SizedBox(height: 15,),
                    Column(
                      children: details.map((item) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${ item.concepto }',
                            style: TextStyle(
                                fontSize: item.concepto == '101 NETO A PAGO' ? 14 : 12,
                                fontWeight: item.concepto == '101 NETO A PAGO' ? FontWeight.w700 : FontWeight.normal,
                                color: item.concepto == '101 NETO A PAGO' ? Colors.blueGrey : Colors.black
                            ),
                          ),
                          Text('S/. ${ item.monto }',
                            style: TextStyle(
                                fontSize: item.concepto == '101 NETO A PAGO' ? 17 : 15,
                                fontWeight: item.concepto == '101 NETO A PAGO' ? FontWeight.w700 : FontWeight.w600,
                                color: item.concepto == '101 NETO A PAGO' ? Colors.blueGrey : Colors.black
                            ),
                          )
                        ],
                      )).toList(),
                    ),
                    Text('__________________________________________________'),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TOTAL',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text('S/. ${ totalDetalle.toStringAsFixed(2) }',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon( Icons.exit_to_app ),
      backgroundColor: Colors.blueAccent,
      onPressed: ()=> Navigator.pushNamed(context, 'search'),
    );
  }

  _settingModalCalendar(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          leading: new Icon(Icons.calendar_today),
                          title: new Text('Seleccione PAGO',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                            ),
                          )
                      ),
                      _buildPayrollsList(context)
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildPayrollsList(BuildContext context) {
    return FutureBuilder(
      future: payrollProvider.getByTrabajador(widget.employee.item3.id),
      builder: (BuildContext context, AsyncSnapshot<List<PlanillaModel>> snapshot) {
        if (snapshot.hasData) {
          final planillas = snapshot.data;
          return Column(
            children: planillas.map((item) => _buildPayrollListItem(context, item)).toList(),
          );

        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildPayrollListItem(BuildContext context, PlanillaModel planilla) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${ planilla.empresa.nombreCorto } - ${ obtenerMes(planilla.mes) } ${ planilla.anio } - ${ planilla.tipoPago.descripcion }',
              style: TextStyle(
                fontSize: 14,
              ),
            )
          ],
        ),
        onTap: () => _search(context, widget.employee.item3.id, '${planilla.anio}-${planilla.mes}', planilla.tipoPago.id, planilla.empresa.id)
      ),
    );
  }

  _search(BuildContext context, String rut, String periodo, int tipoPagoId, int empresaId) async {

    Tuple3<String, bool, EmployeeModel> info = await employeeProvider.cargarPagos(rut, periodo, tipoPagoId, empresaId: empresaId);

    if (info.item3 != null) {
      // print(info);
      Navigator.push(context, new MaterialPageRoute(
          builder: (_) => new HomePage(employee: info,)
      ));
    } else {
      mostrarAlerta(context, info.item1);
    }
  }
}