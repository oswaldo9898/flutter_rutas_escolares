class RegisterConductorRequestModel {
  RegisterConductorRequestModel({
    this.cedula,
    this.nombres,
    this.apellidos,
    this.email,
    this.password,
    this.rol,
    this.path,
    this.imagen64,
  });
  late final String? cedula;
  late final String? nombres;
  late final String? apellidos;
  late final String? password;
  late final String? email;
  late final String? rol;
  late final String? path;
  late final String? imagen64;

  RegisterConductorRequestModel.fromJson(Map<String, dynamic> json) {
    cedula = json['cedula'];
    nombres = json['nombres'];
    apellidos = json['apellidos'];
    email = json['email'];
    password = json['password'];
    rol = json['rol'];
    path = json['path'];
    imagen64 = json['imagen64'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cedula'] = cedula;
    _data['nombres'] = nombres;
    _data['apellidos'] = apellidos;    
    _data['email'] = email;
    _data['password'] = password;
    _data['rol'] = rol;
    _data['path'] = path;
    _data['imagen64'] = imagen64;
    return _data;
  }
}
