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

    EmployeeListModel trabajador = EmployeeListModel.fromJson(json['employee']);
    RolModel rol = RolModel.fromJson(json['rol']);

    return UserListModel(
      id: json['id'],
      username: json['username'],
      trabajador: trabajador,
      rol: rol
    );
  }
}