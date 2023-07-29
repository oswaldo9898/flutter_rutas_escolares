import 'dart:convert';

RegisterEstudianteResponseModel registerEstudianteResponseJson(String str) =>
    RegisterEstudianteResponseModel.fromJson(json.decode(str));

class RegisterEstudianteResponseModel {
  RegisterEstudianteResponseModel({
    required this.message,
    required this.data,
  });
  late final String message;
  late final Data? data;

  RegisterEstudianteResponseModel.fromJson(Map<String, dynamic> json) {
    print(json['message']);
    print('ESTAMOS AQUIIIIIII');
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
    required this.cedula_est,
    required this.nombres_est,
    required this.apellidos_est,
    required this.foto_est,
  });
  late final String cedula_est;
  late final String nombres_est;
  late final String apellidos_est;
  late final String foto_est;

  Data.fromJson(Map<String, dynamic> json) {
    cedula_est = json['cedula_est'];
    nombres_est = json['nombres_est'];
    apellidos_est = json['apellidos_est'];
    foto_est = json['foto_est'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cedula_est'] = cedula_est;
    _data['nombres_est'] = nombres_est;
    _data['apellidos_est'] = apellidos_est;
    _data['foto_est'] = foto_est;
    return _data;
  }
}
