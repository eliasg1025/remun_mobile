import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:remun_mobile/src/bloc/provider.dart';
import 'package:remun_mobile/src/models/employee_model.dart';
import 'package:remun_mobile/src/providers/employee_provider.dart';
import 'package:remun_mobile/src/utils/utils.dart';

class SearchPage extends StatefulWidget
{
  @override
  SearchPageState createState() => SearchPageState();
}


class SearchPageState extends State<SearchPage>
{
  String barcode = "";

  @override
  initState() {
    super.initState();
}

  final employeeProvider = new EmployeeProvider();
  final _rutController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Consulta Sueldos'),
        backgroundColor: Colors.blueAccent[400],
        shadowColor: Colors.white10,
      ),
      body: new Center(
        child: _searchForm(context),
      ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Image(image: AssetImage('assets/logos/grupo-verfrut.png'), height: 100.0,),
                decoration: BoxDecoration(
                    color: Colors.blueAccent
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.monetization_on),
                    SizedBox(width: 10,),
                    Text('Consulta Sueldos'),
                  ],
                ),
                onTap: () => Navigator.pushNamed(context, 'search'),
              ),
              Divider(height: 5, color: Colors.black26,),
              ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.power_settings_new),
                      SizedBox(width: 10,),
                      Text('Cerrar Sesión'),
                    ],
                  ),
                  onTap: ()=> Navigator.pushNamed(context, 'login')
              ),
            ],
          )
      ),
    );
  }

  Widget _searchForm(BuildContext context)
  {
    final bloc = Provider.ofS(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0,
                  )
                ]
            ),
            child: Column(
              children: [
                Text('Consulta de Sueldos',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _crearInputPeriodo(bloc),
                    _crearInputTipoPago(bloc),
                  ],
                ),
                SizedBox(height: 30.0),
                Row(
                    children: [
                      _crearInputRut(bloc),
                      _crearBotonQr(bloc),
                    ]
                ),
                SizedBox(height: 20.0,),
                _crearBotonSubmit(bloc)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _crearInputRut(SearchBloc bloc) {

    return StreamBuilder(
      stream: bloc.rutStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          width: 250,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                //icon: Icon(Icons.supervised_user_circle, color: Colors.blueAccent),
                //hintText: 'Ej: 12345678',
                labelText: 'RUT del trabajador',
                //counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: (value) => bloc.changeRut(value),
            controller: _rutController,
          ),
        );
      },
    );
  }

  Widget _crearBotonQr(SearchBloc bloc) {
    return Container(
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: RaisedButton(
        onPressed: () => scan(bloc),
        child: Text('QR'),
      ),
    );
  }

  Widget _crearInputPeriodo(SearchBloc bloc) {
    return StreamBuilder(
      stream: bloc.periodoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          width: 160,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: DropdownButton<String>(
            hint: Text('Periodo'),
            //icon: Icon(Icons.calendar_today),
            underline: Container(
              height: 2,
              color: Colors.blueAccent,
            ),
            value: bloc.periodo,
            items: <String>['2020-09', '2020-10'].map((value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            )).toList(),
            onChanged: (value) => bloc.changePeriodo(value),
          ),
        );
      },
    );
  }

  Widget _crearInputTipoPago(SearchBloc bloc) {

    return StreamBuilder(
      stream: bloc.tipoPagoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          width: 160,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: DropdownButton<String>(
            hint: Text('Tipo Pago'),
            //icon: Icon(Icons.payment),
            underline: Container(
              height: 2,
              color: Colors.blueAccent,
            ),
            value: bloc.tipoPago,
            items: <String>['SUELDO', 'ANTICIPO'].map((value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            )).toList(),
            onChanged: (value) => bloc.changeTipoPago(value),
          ),
        );
      },
    );
  }

  Widget _crearBotonSubmit(SearchBloc bloc) {
    // formValidStream
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return RaisedButton(
            child: Container(
              child: Text('Buscar Pago'),
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)
            ),
            elevation: 0.0,
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: snapshot.hasData ? () => _search(bloc, context): null,
          );
        }
    );
  }

  _search(SearchBloc bloc, BuildContext context) async {
    print('==================');
    print('RUT: ${ bloc.rut }');
    print('Periodo: ${ bloc.periodo }');
    print('Tipo Pago: ${ bloc.tipoPago }');
    print('==================');

    int tipoPagoId;
    if (bloc.tipoPago == 'SUELDO') {
      tipoPagoId = 1;
    } else {
      tipoPagoId = 2;
    }

    EmployeeModel info = await employeeProvider.cargarPagos(
      bloc.rut,
      bloc.periodo,
      tipoPagoId
    );

    if (info != null) {
      // print(info);
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      mostrarAlerta(context, 'Pago no encontrado para este trabajador');
    }
  }

  Future scan(SearchBloc bloc) async {
    try {
      String barcode = await scanner.scan();

      setState(() {
        this.barcode = barcode;
      });

      bloc.changeRut(barcode);

      _rutController.text = barcode;

    } on PlatformException catch (e) {
      if (e.code == scanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}