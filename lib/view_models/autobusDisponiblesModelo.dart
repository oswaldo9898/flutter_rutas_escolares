import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_autobuses.dart';

import '../models/autobuses/autobus.dart';

class AutobusDisponiblesModelo extends ChangeNotifier {
  List<Autobus> _autobuses = [];
  List<Autobus> get autobuses => _autobuses;

  AutobusDisponiblesModelo() {
    getListaAutobusesDisponibles();
  }

  void actualizarData() {
    getListaAutobusesDisponibles();
  }

  Future<void> getListaAutobusesDisponibles() async {
    _autobuses = [];
    var data = await APIServiceAutobuses.getAutobusesDisponibles();
    for (var item in data) {
      _autobuses.add(Autobus(
          item.idautobus, item.marca, item.modelo, item.placa, item.foto));
    }
    notifyListeners();
  }
}
