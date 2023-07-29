// ignore_for_file: non_constant_identifier_names

class Rutas {
  late int idrutas;
  late String cedula;
  late String placa;
  late String nombre;

  Rutas(this.idrutas, this.cedula, this.placa, this.nombre);

  Rutas.fromJson(Map<String, dynamic> json) {
    idrutas = json['idrutas'];
    cedula = json['cedula'];
    placa = json['placa'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idrutas'] = idrutas;
    data['cedula'] = cedula;
    data['placa'] = placa;
    data['nombre'] = nombre;
    return data;
  }
}
