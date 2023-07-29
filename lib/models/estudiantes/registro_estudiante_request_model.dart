class RegisterEstudianteRequestModel {
  RegisterEstudianteRequestModel({
    this.cedula_est,
    this.nombres_est,
    this.apellidos_est,
    this.path,
    this.imagen64,
    this.latitud,
    this.longitud,
  });
  late final String? cedula_est;
  late final String? nombres_est;
  late final String? apellidos_est;
  late final String? path;
  late final String? imagen64;
  late final double? latitud;
  late final double? longitud;

  RegisterEstudianteRequestModel.fromJson(Map<String, dynamic> json) {
    cedula_est = json['cedula_est'];
    nombres_est = json['nombres_est'];
    apellidos_est = json['apellidos_est'];
    path = json['path'];
    imagen64 = json['imagen64'];
    latitud = json['latitud'];
    longitud = json['longitud'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cedula_est'] = cedula_est;
    _data['nombres_est'] = nombres_est;
    _data['apellidos_est'] = apellidos_est;
    _data['path'] = path;
    _data['imagen64'] = imagen64;
    _data['latitud'] = latitud;
    _data['longitud'] = longitud;
    return _data;
  }
}