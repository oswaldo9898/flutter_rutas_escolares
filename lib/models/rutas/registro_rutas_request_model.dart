class RegisterRutasRequestModel {
  RegisterRutasRequestModel({
    this.idrutas,
    this.cedula,
    this.placa,
    this.nombre
  });
  late final int? idrutas;
  late final String? cedula;
  late final String? placa;
  late final String? nombre;

  RegisterRutasRequestModel.fromJson(Map<String, dynamic> json) {
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
