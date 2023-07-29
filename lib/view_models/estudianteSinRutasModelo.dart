import 'package:flutter/material.dart';
import '../models/estudiantes/estudiante.dart';
import '../services/api_service_rutas.dart';

class EstudianteSinRutasModelo extends ChangeNotifier {
  List<Estudiante> _estudiantes = [];
  List<Estudiante> get estudiantes => _estudiantes;

  EstudianteSinRutasModelo() {
    getListaEstudiantes();
  }

  void actualizarData() {
    getListaEstudiantes();
  }

  Future<void> getListaEstudiantes() async {
    _estudiantes = [];
    var data = await APIServiceRutas.getEstudiantesSinRutas();
    for (var item in data) {
      _estudiantes.add(Estudiante(item.cedula_est, item.nombres_est,
          item.apellidos_est, item.foto_est, item.latitud, item.longitud));
    }
    notifyListeners();
  }
}
