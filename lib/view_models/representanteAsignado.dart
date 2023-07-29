import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_estudiantes.dart';
import '../models/usuarios/usuario.dart';

class RepresentanteAsignado extends ChangeNotifier {
  List<Usuario> _representantes = [];
  List<Usuario> get representantes => _representantes;

  RepresentanteAsignado(cedulaEst) {
    getListaRepresentantes(cedulaEst);
  }

  void actualizarData(cedulaEst) {
    getListaRepresentantes(cedulaEst);
  }

  Future<void> getListaRepresentantes(cedulaEst) async {
    _representantes = [];
    var data = await APIService.getRepresentanteAsignado(cedulaEst);
    for (var item in data) {
      _representantes.add(Usuario(item.cedula, item.nombres,
          item.apellidos, item.email, item.password, item.rol));
    }
    notifyListeners();
  }
}
