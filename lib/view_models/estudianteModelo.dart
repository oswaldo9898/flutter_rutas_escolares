import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_estudiantes.dart';
import '../models/estudiantes/estudiante.dart';

class EstudianteModelo extends ChangeNotifier {
  List<Estudiante> _estudiantes = [];
  List<Estudiante> get estudiantes => _estudiantes;
  int cantRutas = 0;

  EstudianteModelo() {
    getListaEstudiantes();
  }

  void actualizarData() {
    getListaEstudiantes();
  }

  Future<void> getListaEstudiantes() async {
    _estudiantes = [];
    var data = await APIService.getEstudiantes();
    for (var item in data) {
      _estudiantes.add(Estudiante(item.cedula_est, item.nombres_est,
          item.apellidos_est, item.foto_est, item.latitud, item.longitud));
    }
    notifyListeners();
  }
}
