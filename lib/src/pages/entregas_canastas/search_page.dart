import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:remun_mobile/src/bloc/provider.dart';
import 'package:remun_mobile/src/models/employee_model.dart';
import 'package:remun_mobile/src/providers/employee_provider.dart';
import 'package:remun_mobile/src/providers/entrega_canasta_provider.dart';
import 'package:remun_mobile/src/utils/utils.dart';
import 'package:remun_mobile/src/widgets/drawer.dart';
import 'package:tuple/tuple.dart';

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

  // State
  EmployeeModel employeeModel;

  // Providers
  final employeeProvider = new EmployeeProvider();
  final entregaCanastaProvider = new EntregaCanastaProvider();

  // Controllers
  final _rutController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    /*
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Consulta Sueldos'),
          backgroundColor: Colors.blueAccent[400],
          shadowColor: Colors.white10,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.contacts), text: 'Consulta',),
              Tab(icon: Icon(Icons.contacts), text: 'Crear Usuarios',)
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _searchForm(context),
            Text('bye')
          ],
        ),
        drawer: _crearDrawer(context)
      )
    );
    */

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Entrega Canastas'),
        backgroundColor: Colors.blueAccent[400],
        shadowColor: Colors.white10,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchForm(context),
            _buildEntregaCanasta(context)
          ],
        ),
      ),
      drawer: buildDrawer(context)
    );
  }

  Widget _buildSearchForm(BuildContext context) {
    final bloc = Provider.ofS(context);
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.85,
      padding: EdgeInsets.symmetric(vertical: 30.0),
      margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30),
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
          Text('Entrega Canastas',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 40.0),
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

  Widget _crearBotonSubmit(SearchBloc bloc) {
    // formValidStream
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return RaisedButton(
            child: Container(
              child: Text('Buscar'),
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)
            ),
            elevation: 0.0,
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () => _search(bloc, context),
          );
        }
    );
  }

  Widget _buildEntregaCanasta(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.85,
      padding: EdgeInsets.symmetric(vertical: 30.0),
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
      child: this.employeeModel == null ? Column(
        children: <Widget>[
          Text('No Data',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: size.height * 0.025
            ),
          )
        ],
      ) : _buildInformacionEntregaCanasta(context),
    );
  }

  Widget _buildInformacionEntregaCanasta(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Text(
          '${this.employeeModel.nombre} ${this.employeeModel.apellidoPaterno} ${this.employeeModel.apellidoMaterno}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          'RUT: ${this.employeeModel.id}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey
          )
        ),
        SizedBox(height: 20,),
        _buildMarcarEntregado(context),
        SizedBox(height: 20,),
        this.employeeModel.entregaCanasta != null
            ? _buildInfoEntrega(context)
            : SizedBox(height: 0,),
      ],
    );
  }

  Widget _buildMarcarEntregado(BuildContext context) {

    final size = MediaQuery.of(context).size;
    bool seEntrego = this.employeeModel.entregaCanasta != null;

    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        width: size.width * 0.60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check),
            Text(!seEntrego ? 'ENTREGAR CANASTA' : 'YA SE ENTREGÓ CANASTA',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white
              ),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0)
      ),
      color: Colors.green,
      textColor: Colors.white,
      onPressed: !seEntrego ? () => _createEntregaCanasta(context, this.employeeModel.id) : null,
    );
  }

  Widget _buildInfoEntrega(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final entregaCanasta = this.employeeModel.entregaCanasta;

    return Container(
      width: size.width * 0.70,
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Registrado por: ${entregaCanasta.usuario.trabajador.nombre} ${entregaCanasta.usuario.trabajador.apellidoPaterno} ${entregaCanasta.usuario.trabajador.apellidoMaterno}'),
          SizedBox(height: 10,),
          Text('Fecha y hora: ${entregaCanasta.createdAt.day}/${entregaCanasta.createdAt.month}/${entregaCanasta.createdAt.year} ${entregaCanasta.createdAt.hour}:${entregaCanasta.createdAt.minute}')
        ],
      ),
    );
  }

  _search(SearchBloc bloc, BuildContext context) async {

    Tuple2<String, dynamic> info = await employeeProvider.getEntregasCanastas(bloc.rut);

    if (info.item2 != null) {
      mostrarAlertaConTitulo(context, info.item1, info.item1, Icon(Icons.check, color: Colors.green[700],),);
      setState(() {
        this.employeeModel = info.item2;  
      });
    } else {
      mostrarAlerta(context, info.item1);
      setState(() {
        this.employeeModel = null;  
      });
    }
  }

  _createEntregaCanasta(BuildContext context, employeeId) async {
    Map<String, dynamic> result = await entregaCanastaProvider.create(employeeId);

    Tuple2<String, dynamic> info = await employeeProvider.getEntregasCanastas(employeeId);
    if (info.item2 != null) {
      this.employeeModel = info.item2;
    } else {
      this.employeeModel = null;
    }

    mostrarAlertaConTitulo(context, result['message'], 'Entrega Canastas', Icon(Icons.message));
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