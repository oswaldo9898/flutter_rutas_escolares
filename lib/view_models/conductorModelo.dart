import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_conductores.dart';

import '../models/conductores/conductor.dart';



class ConductorModelo extends ChangeNotifier {
  List<Conductor> _conductores = [];
  List<Conductor> get conductores => _conductores;

  ConductorModelo() {
    getListaConductores();
  }

  void actualizarData() {
    getListaConductores();
  }

  Future<void> getListaConductores() async {
    _conductores = [];
    var data = await APIServiceConductores.getConductores();
    for (var item in data) {
      _conductores.add(Conductor(item.cedula, item.nombres, item.apellidos, item.email, item.rol, item.foto));
    }
    notifyListeners();
  }
}
