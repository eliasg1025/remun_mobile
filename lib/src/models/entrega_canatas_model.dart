import 'package:remun_mobile/src/models/empresa_model.dart';
import 'package:remun_mobile/src/models/user_list_model.dart';

class EntregaCanastaModel
{
  int id;
  DateTime createdAt;
  UserListModel usuario;

  EntregaCanastaModel({
    this.id,
    this.createdAt,
    this.usuario
  });

  factory EntregaCanastaModel.fromJsonMap(Map<String, dynamic> json)
  {
    UserListModel usuario = UserListModel.fromJson(json['usuario']);

    return EntregaCanastaModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      usuario: usuario
    );
  }
}