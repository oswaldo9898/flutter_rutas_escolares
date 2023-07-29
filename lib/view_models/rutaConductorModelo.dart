import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_rutas.dart';
import '../models/rutas/rutas.dart';

class RutaConductorModelo extends ChangeNotifier {
  List<Rutas> _rutas = [];
  List<Rutas> get rutas => _rutas;

  RutaConductorModelo(cedula) {
    getListaRutas(cedula);
  }

  void actualizarData(cedula) {
    getListaRutas(cedula);
  }

  Future<void> getListaRutas(cedula) async {
    _rutas = [];
    var data = await APIServiceRutas.getRutasConductor(cedula);
    for (var item in data) {
      _rutas.add(Rutas(
          item.idrutas, item.cedula, item.placa, item.nombre));
    }
    notifyListeners();
  }
}
