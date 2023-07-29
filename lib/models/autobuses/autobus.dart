// ignore_for_file: non_constant_identifier_names

class Autobus {
  late int idautobus;
  late String marca;
  late String modelo;
  late String placa;
  late String foto;

  Autobus(this.idautobus, this.marca, this.modelo, this.placa, this.foto);

  Autobus.fromJson(Map<String, dynamic> json) {
    idautobus = json['idautobus'];
    marca = json['marca'];
    modelo = json['modelo'];
    placa = json['placa'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idautobus'] = idautobus;
    data['marca'] = marca;
    data['modelo'] = modelo;
    data['placa'] = placa;
    data['foto'] = foto;
    return data;
  }
}
