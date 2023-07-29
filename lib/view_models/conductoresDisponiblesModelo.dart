import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_conductores.dart';

import '../models/conductores/conductor.dart';

class ConductoresDisponiblesModelo extends ChangeNotifier {
  List<Conductor> _conductores = [];
  List<Conductor> get conductores => _conductores;

  ConductoresDisponiblesModelo() {
    getListaConductoresDisponibles();
  }

  void actualizarData() {
    getListaConductoresDisponibles();
  }

  Future<void> getListaConductoresDisponibles() async {
    _conductores = [];
    var data = await APIServiceConductores.getConductoresDisponibles();
    for (var item in data) {
      _conductores.add(Conductor(item.cedula, item.nombres, item.apellidos,
          item.email, item.rol, item.foto));
    }
    notifyListeners();
  }
}
