import 'dart:convert';
import 'package:frontend_flutter/models/estudiantes/estudiante_direccion.dart';
import 'package:frontend_flutter/models/usuarios/usuario.dart';
import 'package:frontend_flutter/services/shared_service.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/estudiantes/estudiante.dart';
import '../models/login_registro/login_request_model.dart';
import '../models/login_registro/login_response_model.dart';
import '../models/estudiantes/registro_estudiante_request_model.dart';
import '../models/estudiantes/registro_estudiante_response_model.dart';
import '../models/login_registro/registro_request_model.dart';
import '../models/login_registro/registro_response_model.dart';
import '../models/rutas/registro_rutas_response_model.dart';

class APIService {
  static var client = http.Client();

  static Future<String> login(
    LoginRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.loginAPI,
    );
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(
        loginResponseJson(
          response.body,
        ),
      );
      LoginResponseModel? _rol = await SharedService.loginDetails();
      return _rol!.data.rol;
    } else {
      return 'null';
    }
  }

  static Future<RegisterResponseModel> register(
    RegisterRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.registerAPI,
    );
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    return registerResponseJson(
      response.body,
    );
  }

  static Future<List<Usuario>> getRepresentantesSinAsignar(
      String cedula) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.representantesSinAsignarAPI + cedula,
    );
    var response = await client.get(url, headers: requestHeaders);
    final List data = json.decode(response.body);
    return data.map((e) => Usuario.fromJson(e)).toList();
  }

  static Future<List<Usuario>> getRepresentanteAsignado(cedulaEst) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url =
        Uri.parse(Config.apiURL + Config.representanteAsignadoAPI + cedulaEst);
    var response = await client.get(url, headers: requestHeaders);
    final List data = json.decode(response.body);
    return data.map((e) => Usuario.fromJson(e)).toList();
  }

  static Future<String> registerRepresentantesSinAsignar(
      cedulaEst, cedula) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL +
          Config.registerRepresentanteAPI +
          cedulaEst.toString() +
          '/' +
          cedula.toString(),
    );
    var response = await client.post(url, headers: requestHeaders);
    return response.body;
  }

  static Future<String> eliminarRepresentanteAsignado(cedulaEst) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL +
          Config.eliminarRepresentanteAsignadoAPI +
          cedulaEst.toString(),
    );
    var response = await client.delete(url, headers: requestHeaders);
    return response.body;
  }

  static Future<RegisterEstudianteResponseModel> registerEstudiante(
    RegisterEstudianteRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.registerEstudianteAPI,
    );
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    print(response.body);
    return registerEstudianteResponseJson(
      response.body,
    );
  }

  static Future<List<Estudiante>> getEstudiantes() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.listaEstudiantesAPI,
    );
    var response = await client.get(url, headers: requestHeaders);
    final List data = json.decode(response.body);
    return data.map((e) => Estudiante.fromJson(e)).toList();
  }

  static Future<List<Estudiante>> getEstudiantesRepresentante(cedula) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.listaEstudiantesRepresentanteAPI + cedula,
    );
    var response = await client.get(url, headers: requestHeaders);
    final List data = json.decode(response.body);
    return data.map((e) => Estudiante.fromJson(e)).toList();
  }

  static Future<RegisterEstudianteResponseModel> registerEstudianteDirecion(
    EstudianteDireccion model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.registroEstudianteDireccionAPI,
    );
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    return registerEstudianteResponseJson(
      response.body,
    );
  }

  static Future<RegisterEstudianteResponseModel> editarEstudiante(
    RegisterEstudianteRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(Config.apiURL + Config.editarEstudianteAPI);
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    return registerEstudianteResponseJson(
      response.body,
    );
  }

  static Future<String> eliminarEstudiante(cedula) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.eliminarEstudianteAPI + cedula,
    );
    var response = await client.delete(url, headers: requestHeaders);
    return response.body;
  }

  static Future<int> cantidadEstudiantes() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.cantidadEstudianteAPI,
    );
    var response = await client.get(url, headers: requestHeaders);
    Map<String, dynamic> respuesta = jsonDecode(response.body);
    return respuesta['data'];
  }

  static Future<String> registerIdRepresentantes(cedula, id) async {
    final _data = <String, dynamic>{};
    _data['id'] = id;

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.registerIdRepresentanteAPI + cedula.toString(),
    );
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(_data));
    return response.body;
  }

  static Future<String> eliminarIdRepresentantes(cedula) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.registerIdRepresentanteAPI + cedula.toString(),
    );
    var response = await client.post(url, headers: requestHeaders);
    return response.body;
  }

  static Future<RegisterRutasResponseModel> getRutaEstudiantes(cedula) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.obtenerRutaEstudianteAPI + cedula,
    );
    var response = await client.get(url, headers: requestHeaders);
    return registerRutasResponseJson(
      response.body,
    );
  }

  static Future<LoginResponseModel> cambiarPassword(
      String passwordAnterior, String passwordNueva, String cedula) async {
    final _data = <String, dynamic>{};
    _data['cedula'] = cedula;
    _data['passwordAnterior'] = passwordAnterior;
    _data['passwordNueva'] = passwordNueva;

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.parse(
      Config.apiURL + Config.cambiarPasswordAPI,
    );
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(_data),
    );
    return loginResponseJson(
      response.body,
    );
  }

  static Future<String> eliminarUsuario(cedula) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.eliminarUsuarioAPI + cedula.toString(),
    );
    var response = await client.delete(url, headers: requestHeaders);
    return response.body;
  }
}
