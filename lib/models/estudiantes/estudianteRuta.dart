// ignore_for_file: non_constant_identifier_names

class EstudianteRuta {
  late String cedula_est;
  late String nombres_est;
  late String apellidos_est;
  late String foto_est;
  late double latitud;
  late double longitud;
  late String cedula;

  EstudianteRuta(
      this.cedula_est, this.nombres_est, this.apellidos_est, this.foto_est, this.latitud, this.longitud, this.cedula);

  EstudianteRuta.fromJson(Map<String, dynamic> json) {
    cedula_est = json['cedula_est'];
    nombres_est = json['nombres_est'];
    apellidos_est = json['apellidos_est'];
    foto_est = json['foto_est'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    cedula = json['cedula'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cedula_est'] = cedula_est;
    data['nombres_est'] = nombres_est;
    data['apellidos_est'] = apellidos_est;
    data['foto_est'] = foto_est;
    data['latitud'] = latitud;
    data['longitud'] = longitud;
    data['cedula'] = cedula;
    return data;
  }
}
