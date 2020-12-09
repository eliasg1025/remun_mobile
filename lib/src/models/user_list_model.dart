import 'package:remun_mobile/src/models/employee_list_model.dart';
import 'package:remun_mobile/src/models/rol_model.dart';

class UserListModel
{
  int id;
  String username;
  EmployeeListModel trabajador;
  RolModel rol;

  UserListModel({
    this.id,
    this.username,
    this.trabajador,
    this.rol
  });

  factory UserListModel.fromJson(Map<String, dynamic> json) {
    EmployeeListModel trabajador;
    if (json.containsKey('trabajador')) {
      trabajador = EmployeeListModel.fromJson(json['trabajador']);
    } else {
      trabajador = EmployeeListModel.fromJson(json['employee']);
    }
    
    RolModel rol = json.containsKey('rol') ? RolModel.fromJson(json['rol']) : null;

    return UserListModel(
      id: json['id'],
      username: json['username'],
      trabajador: trabajador,
      rol: rol
    );
  }
}