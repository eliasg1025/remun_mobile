import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:remun_mobile/src/models/employee_list_model.dart';
import 'package:remun_mobile/src/models/user_list_model.dart';
import 'package:remun_mobile/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:remun_mobile/src/providers/employee_provider.dart';
import 'package:remun_mobile/src/providers/users_provider.dart';
import 'package:remun_mobile/src/utils/utils.dart';

import '../widgets/drawer.dart';

class UsersPage extends StatefulWidget {
  @override
  UsersPageState createState() => UsersPageState();
}

class UsersPageState extends State<UsersPage>
{
  final _prefs = PreferenciasUsuario();
  final usersProvider = new UserProvider();
  final employeeProvider = new EmployeeProvider();

  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();
  final rutController = new TextEditingController();

  EmployeeListModel currentEmployee;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> decodedToken = JwtDecoder.decode(_prefs.token);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Gestión Usuarios'),
        backgroundColor: Colors.blueAccent[400],
        shadowColor: Colors.white10,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAddUserForm(context),
              SizedBox(height: 25,),
              _buildUsersList(context)
            ],
          ),
        )
      ),
      drawer: buildDrawer(context)
    );
  }

  Widget _buildUsersList(BuildContext context) {

    return FutureBuilder(
      future: usersProvider.get(),
      builder: (BuildContext context, AsyncSnapshot<List<UserListModel>> snapshot) {
        if (snapshot.hasData) {

          final users = snapshot.data;

          return Column(
              children: users.map((user) => _buildUserListItem(context, user)).toList()
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  Widget _buildUserListItem(BuildContext context, UserListModel user) {

    final trabajador = user.trabajador;
    final rol = user.rol;

    return Container(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${ user.username }',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700
              ),
            ),
            Text('${ trabajador.nombre } ${ trabajador.apellidoPaterno } ${ trabajador.apellidoMaterno }')
          ],
        ),
        subtitle: Text('ROL: ${ rol.descripcion }'),
        onTap: () => print('hi'),
      ),
      margin: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Widget _buildAddUserForm(BuildContext context) {

    double width = MediaQuery.of(context).size.width * 0.9;

    return Card(
      child: Container(
        width: width,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Crear Usuario',
              style: TextStyle(
                fontWeight: FontWeight.w600
              ),
            ),
            _buildSearchTrabajador(context),
            TextFormField(
              enabled: currentEmployee != null,
              keyboardType: TextInputType.text,
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Ingrese Nombre de Usuario',
              ),
            ),
            TextFormField(
              enabled: currentEmployee != null,
              keyboardType: TextInputType.text,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Ingrese contraseña'
              ),
            ),
            SizedBox(height: 10,),
            RaisedButton(
              onPressed: () => _createOtherUser(context),
              child: Text('Crear'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTrabajador(BuildContext context) {

    return Row(
      children: [
        Container(
          width: 250,
          child: TextField(
            keyboardType: TextInputType.visiblePassword,
            controller: rutController,
            decoration: InputDecoration(
              labelText: 'Buscar por RUT',
              counterText: currentEmployee?.toString()
            ),
          ),
        ),
        Container(
          width: 50,
          child: FlatButton(
            onPressed: () => _searchTrabajador(context, rutController.text),
            child: Icon(Icons.search),
          ),
        )
      ],
    );
  }

  _createOtherUser(BuildContext context) async {
    print(rutController.text);
    print(usernameController.text);
    print(passwordController.text);

    Map<String, dynamic> result = await usersProvider.create(
      usernameController.text.toString(),
      passwordController.text.toString(),
      rutController.text.toString(),
      '2'
    );

    mostrarAlertaConTitulo(context, result['message'], 'Creación de usuarios');
  }

  _searchTrabajador(BuildContext context, String trabajadorId) async {
    final data = await employeeProvider.show(trabajadorId);

    setState(() {
      currentEmployee = data;
    });
    
    if (currentEmployee != null) {
      mostrarAlertaConTitulo(context, 'Trabajador encontrado', 'Crear usuario');
    } else {
      mostrarAlertaConTitulo(context, 'Trabajador NO encontrado', 'Crear usuario');
    }
  }
}