// ignore_for_file: non_constant_identifier_names

class Conductor {
  late String cedula;
  late String nombres;
  late String apellidos;
  late String email;
  late String rol;
  late String foto;

  Conductor(this.cedula, this.nombres, this.apellidos, this.email, this.rol, this.foto);

  Conductor.fromJson(Map<String, dynamic> json) {
    cedula = json['cedula'];
    nombres = json['nombres'];
    apellidos = json['apellidos'];
    email = json['email'];
    rol = json['rol'];
    foto = json['foto_con'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cedula'] = cedula;
    data['nombres'] = nombres;
    data['apellidos'] = apellidos;
    data['email'] = email;
    data['rol'] = rol;
    data['foto'] = foto;
    return data;
  }
}
