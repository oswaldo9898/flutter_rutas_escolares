class RegisterAutobusRequestModel {
  RegisterAutobusRequestModel({
    this.idautobus,
    this.marca,
    this.modelo,
    this.placa,
    this.path,
    this.imagen64,
  });
  late final int? idautobus;
  late final String? marca;
  late final String? modelo;
  late final String? placa;
  late final String? path;
  late final String? imagen64;

  RegisterAutobusRequestModel.fromJson(Map<String, dynamic> json) {
    idautobus = json['idautobus'];
    marca = json['marca'];
    modelo = json['modelo'];
    placa = json['placa'];
    path = json['path'];
    imagen64 = json['imagen64'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['idautobus'] = idautobus;
    _data['marca'] = marca;
    _data['modelo'] = modelo;
    _data['placa'] = placa;
    _data['path'] = path;
    _data['imagen64'] = imagen64;
    return _data;
  }
}
