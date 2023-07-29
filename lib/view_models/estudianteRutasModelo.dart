import 'package:flutter/material.dart';
import '../models/estudiantes/estudiante.dart';
import '../services/api_service_rutas.dart';

class EstudianteRutasModelo extends ChangeNotifier {
  List<Estudiante> _estudiantes = [];
  List<Estudiante> get estudiantes => _estudiantes;

  EstudianteRutasModelo(idrutaestudiante) {
    getListaEstudiantes(idrutaestudiante);
  }

  void actualizarData(idrutaestudiante) {
    getListaEstudiantes(idrutaestudiante);
  }

  Future<void> getListaEstudiantes(idrutas) async {
    _estudiantes = [];
    var data = await APIServiceRutas.getEstudiantesRutas(idrutas);
    for (var item in data) {
      _estudiantes.add(Estudiante(item.cedula_est, item.nombres_est,
          item.apellidos_est, item.foto_est, item.latitud, item.longitud));
    }
    notifyListeners();
  }
}
