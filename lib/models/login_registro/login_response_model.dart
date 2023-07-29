import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.message,
    required this.data,
    required this.token,
  });
  late final String message;
  late final Data data;
  late final String token;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = Data.fromJson(json['data']);
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data.toJson();
    _data['token'] = token;
    return _data;
  }
}

class Data {
  Data({
    required this.cedula,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.rol,
  });
  late final String cedula;
  late final String nombres;
  late final String apellidos;
  late final String email;
  late final String rol;

  Data.fromJson(Map<String, dynamic> json) {
    cedula = json['cedula'];
    nombres = json['nombres'];
    apellidos = json['apellidos'];
    email = json['email'];
    rol = json['rol'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cedula'] = cedula;
    _data['nombres'] = nombres;
    _data['apellidos'] = apellidos;
    _data['email'] = email;
    _data['rol'] = rol;
    return _data;
  }
}