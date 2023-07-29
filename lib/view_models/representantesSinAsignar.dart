import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_estudiantes.dart';
import '../models/usuarios/usuario.dart';

class RepresentantesSinAsignar extends ChangeNotifier {
  List<Usuario> _representantes = [];
  List<Usuario> get representantes => _representantes;

  RepresentantesSinAsignar(String cedula) {
    getListaRepresentantes(cedula);
  }

  void actualizarData(cedula) {
    getListaRepresentantes(cedula);
  }

  Future<void> getListaRepresentantes(String cedula) async {
    _representantes = [];
    var data = await APIService.getRepresentantesSinAsignar(cedula);
    for (var item in data) {
      _representantes.add(Usuario(item.cedula, item.nombres, item.apellidos,
          item.email, item.password, item.rol));
    }
    notifyListeners();
  }
}
