class RegisterRequestModel {
  RegisterRequestModel({
    this.cedula,
    this.nombres,
    this.apellidos,
    this.email,
    this.password,
    this.rol,
  });
  
  late final String? cedula;
  late final String? nombres;
  late final String? apellidos;
  late final String? password;
  late final String? email;
  late final String? rol;

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    cedula = json['cedula'];
    nombres = json['nombres'];
    apellidos = json['apellidos'];
    email = json['email'];
    password = json['password'];
    rol = json['rol'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cedula'] = cedula;
    _data['nombres'] = nombres;
    _data['apellidos'] = apellidos;    
    _data['email'] = email;
    _data['password'] = password;
    _data['rol'] = rol;
    return _data;
  }
}