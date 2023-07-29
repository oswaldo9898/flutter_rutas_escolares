import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_rutas.dart';
import '../models/rutas/rutas.dart';

class RutaModelo extends ChangeNotifier {
  List<Rutas> _rutas = [];
  List<Rutas> get rutas => _rutas;

  RutaModelo() {
    getListaRutas();
  }

  void actualizarData() {
    getListaRutas();
  }

  Future<void> getListaRutas() async {
    _rutas = [];
    var data = await APIServiceRutas.getRutas();
    for (var item in data) {
      _rutas.add(Rutas(
          item.idrutas, item.cedula, item.placa, item.nombre));
    }
    notifyListeners();
  }
}
