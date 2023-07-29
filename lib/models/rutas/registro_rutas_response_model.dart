import 'dart:convert';

RegisterRutasResponseModel registerRutasResponseJson(String str) =>
    RegisterRutasResponseModel.fromJson(json.decode(str));

class RegisterRutasResponseModel {
  RegisterRutasResponseModel({
    required this.message,
    required this.data,
  });
  late final String message;
  late final Data? data;

  RegisterRutasResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data!.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.idrutas,
    required this.cedula,
    required this.placa,
    required this.nombre
  });
  late final int idrutas;
  late final String cedula;
  late final String placa;
  late final String nombre;

  Data.fromJson(Map<String, dynamic> json) {
    idrutas = json['idrutas'];
    cedula = json['cedula'];
    placa = json['placa'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['idrutas'] = idrutas;
    _data['cedula'] = cedula;
    _data['placa'] = placa;
    _data['nombre'] = nombre;
    return _data;
  }
}
