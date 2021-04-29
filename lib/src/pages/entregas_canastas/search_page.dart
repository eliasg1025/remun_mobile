import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:remun_mobile/src/models/employee_model.dart';
import 'package:remun_mobile/src/pages/entregas_canastas/reportes.dart';
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
  bool loading = false;
  bool loadingEntrega = false;
  Map<String, dynamic> form = {
    'rut': '',
  };

  // Providers
  final employeeProvider = new EmployeeProvider();
  final entregaCanastaProvider = new EntregaCanastaProvider();

  // Controllers
  final _rutController = new TextEditingController();


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Entrega Canastas'),
          backgroundColor: Colors.blueAccent[400],
          shadowColor: Colors.white10,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Entrega',),
              Tab(text: 'Reportes',)
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEntregaView(context),
            //_buildReportesView(context),
            new ReportesView()
          ],
        ),
        drawer: buildDrawer(context)
      )
    );

    /* return Scaffold(
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
    ); */
  }

  Widget _buildEntregaView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildSearchForm(context),
          _buildEntregaCanasta(context)
        ],
      ),
    );
  }

  Widget _buildReportesView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text('reportes')
        ],
      ),
    );
  }

  Widget _buildSearchForm(BuildContext context) {
    
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
                _crearInputRut(),
                _crearBotonQr(),
              ]
          ),
          SizedBox(height: 20.0,),
          _crearBotonSubmit()
        ],
      ),
    );
  }

  Widget _crearInputRut() {
    return Container(
      width: 250,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            labelText: 'RUT del trabajador',
        ),
        onChanged: (value) => _handleInput(value),
        controller: _rutController,
      ),
    );
  }

  Widget _crearBotonQr() {
    return Container(
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: RaisedButton(
        onPressed: () => scan(),
        child: Text('QR'),
      ),
    );
  }

  Widget _crearBotonSubmit() {
    // formValidStream
    return RaisedButton(
      child: Container(
        child: !this.loading ? Text('Buscar') : CircularProgressIndicator(),
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      elevation: 0.0,
      color: Colors.blueAccent,
      textColor: Colors.white,
      onPressed: !this.loading ? () => _search(this.form['rut'], context) : null,
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
        child: !this.loadingEntrega ? Row(
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
        ) : CircularProgressIndicator(),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0)
      ),
      color: Colors.green,
      textColor: Colors.white,
      onPressed: !seEntrego && !this.loadingEntrega ? () => _createEntregaCanasta(context, this.employeeModel.id) : null,
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

  _search(String rut, BuildContext context) async {
    setState(() {
      this.loading = true;
    });
    Tuple2<String, dynamic> info = await employeeProvider.getEntregasCanastas(rut);

    if (info.item2 != null) {
      mostrarAlertaConTitulo(context, info.item1, info.item1, Icon(Icons.check, color: Colors.green[700],),);
      setState(() {
        this.employeeModel = info.item2;
        this.loading = false;
      });
    } else {
      mostrarAlerta(context, info.item1);
      setState(() {
        this.employeeModel = null;
        this.loading = false;
      });
    }
  }

  _createEntregaCanasta(BuildContext context, employeeId) async {
    setState(() {
      this.loadingEntrega = true;
    });
    Map<String, dynamic> result = await entregaCanastaProvider.create(employeeId);

    Tuple2<String, dynamic> info = await employeeProvider.getEntregasCanastas(employeeId);
    if (info.item2 != null) {
      setState(() {
        this.employeeModel = info.item2;
        this.loadingEntrega = false;
      });
    } else {
      setState(() {
        this.employeeModel = null;
        this.loadingEntrega = false;
      });
    }

    mostrarAlertaConTitulo(context, result['message'], 'Entrega Canastas', Icon(Icons.message));
  }

  _handleInput(value) {
    setState(() {
      this.form['rut'] = value;
    });
  }

  Future scan() async {
    try {
      String barcode = await scanner.scan();

      setState(() {
        this.barcode = barcode;
        this.form['rut'] = barcode;
      });

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