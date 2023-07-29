// ignore_for_file: non_constant_identifier_names

class EstudianteDireccion {
  late String cedula_est;
  late double latitud;
  late double longitud;

  EstudianteDireccion(this.cedula_est, this.latitud, this.longitud);

  EstudianteDireccion.fromJson(Map<String, dynamic> json) {
    cedula_est = json['cedula_est'];
    latitud = json['latitud'];
    longitud = json['longitud'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cedula_est'] = cedula_est;
    data['latitud'] = latitud;
    data['longitud'] = longitud;
    return data;
  }
}