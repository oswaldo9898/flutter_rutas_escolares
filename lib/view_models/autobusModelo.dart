import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_autobuses.dart';

import '../models/autobuses/autobus.dart';

class AutobusModelo extends ChangeNotifier {
  List<Autobus> _autobuses = [];
  List<Autobus> get autobuses => _autobuses;

  AutobusModelo() {
    getListaAutobuses();
  }

  void actualizarData() {
    getListaAutobuses();
  }

  Future<void> getListaAutobuses() async {
    _autobuses = [];
    var data = await APIServiceAutobuses.getAutobuses();
    for (var item in data) {
      _autobuses.add(Autobus(
          item.idautobus, item.marca, item.modelo, item.placa, item.foto));
    }
    notifyListeners();
  }
}
