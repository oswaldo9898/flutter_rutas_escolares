import 'dart:convert';

RegisterAutobusResponseModel registerAutobusResponseJson(String str) =>
    RegisterAutobusResponseModel.fromJson(json.decode(str));

class RegisterAutobusResponseModel {
  RegisterAutobusResponseModel({
    required this.message,
    required this.data,
  });
  late final String message;
  late final Data? data;

  RegisterAutobusResponseModel.fromJson(Map<String, dynamic> json) {
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
    required this.idautobus,
    required this.marca,
    required this.modelo,
    required this.placa,
    required this.foto,
  });
  late final int idautobus;
  late final String marca;
  late final String modelo;
  late final String placa;
  late final String foto;

  Data.fromJson(Map<String, dynamic> json) {
    idautobus = json['idautobus'];
    marca = json['marca'];
    modelo = json['modelo'];
    placa = json['placa'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['idautobus'] = idautobus;
    _data['marca'] = marca;
    _data['modelo'] = modelo;
    _data['placa'] = placa;
    _data['foto'] = foto;
    return _data;
  }
}
