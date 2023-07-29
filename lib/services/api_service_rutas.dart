import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/estudiantes/estudiante.dart';
import '../models/estudiantes/estudianteRuta.dart';
import '../models/rutas/registro_rutas_request_model.dart';
import '../models/rutas/registro_rutas_response_model.dart';
import '../models/rutas/rutas.dart';
import 'api_base_helper.dart';
import 'app_exceptions.dart';

class APIServiceRutas {
  static var client = http.Client();

  static Future<List<Rutas>> getRutas() async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };
      var url = Uri.parse(
        Config.apiURL + Config.listaRutasAPI,
      );
      var response = await client.get(url, headers: requestHeaders);
      final List data = json.decode(response.body);
      return data.map((e) => Rutas.fromJson(e)).toList();
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        throw Exception("Connection Timeout Exception");
      }
      throw Exception(e.message);
    }
  }

  static Future<List<Rutas>> getRutasConductor(cedula) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.listaRutasConductorAPI + cedula,
    );
    var response = await client.get(url, headers: requestHeaders);
    final List data = json.decode(response.body);
    return data.map((e) => Rutas.fromJson(e)).toList();
  }

  static Future<RegisterRutasResponseModel> registerRutas(
    RegisterRutasRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.registerRutaAPI,
    );
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    return registerRutasResponseJson(
      response.body,
    );
  }

  static Future<String> eliminarRuta(idrutas) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.eliminarRutaAPI + idrutas.toString(),
    );
    var response = await client.delete(url, headers: requestHeaders);
    return response.body;
  }

  static Future<List<Estudiante>> getEstudiantesSinRutas() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.listaEstudiantesSinRutasAPI,
    );
    var response = await client.get(url, headers: requestHeaders);
    final List data = json.decode(response.body);
    return data.map((e) => Estudiante.fromJson(e)).toList();
  }

  static Future<List<EstudianteRuta>> getEstudiantesRutas(idrutas) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };
      var url = Uri.parse(
        Config.apiURL + Config.listaEstudiantesRutasAPI + idrutas.toString(),
      );
      var response = await client.get(url, headers: requestHeaders);
      final List data = returnResponse(response);
      return data.map((e) => EstudianteRuta.fromJson(e)).toList();
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  static Future<String> eliminarEstudianteRuta(cedula) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.eliminarEstudianteRutaAPI + cedula.toString(),
    );
    var response = await client.delete(url, headers: requestHeaders);
    return response.body;
  }

  static Future<String> registerEstudianteRutas(cedula, idrutas) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL +
          Config.registerEstudianteRutaAPI +
          cedula.toString() +
          '/' +
          idrutas.toString(),
    );
    var response = await client.post(url, headers: requestHeaders);
    return response.body;
  }

  static Future<int> cantidadRutas() async {
    Map<String, dynamic> respuesta;
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };
      var url = Uri.parse(
        Config.apiURL + Config.cantidadRutaAPI,
      );
      var response = await client.get(url, headers: requestHeaders);
      respuesta = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return respuesta['data'];
  }

  static Future<void> enviarNotificaciondispositivo(cedula, mensaje) async {
    final _data = <String, dynamic>{};
    _data['cedula'] = cedula;

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.notificacionDispositivoAPI + mensaje.toString(),
    );
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(_data));
  }

  static Future<void> enviarNotificacionRutas(ruta, mensaje) async {
    final _data = <String, dynamic>{};
    _data['ruta'] = ruta;

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.notificacionRutasAPI + mensaje.toString(),
    );
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(_data));
  }
}
