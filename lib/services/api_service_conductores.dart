import 'dart:convert';
import 'package:frontend_flutter/models/conductores/conductor.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/conductores/registro_conductor_request_model.dart';
import '../models/conductores/registro_conductor_response_model.dart';

class APIServiceConductores {
  static var client = http.Client();

  static Future<List<Conductor>> getConductores() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.listaConductoresAPI,
    );
    var response = await client.get(url, headers: requestHeaders);
    final List data = json.decode(response.body);
    return data.map((e) => Conductor.fromJson(e)).toList();
  }

  static Future<List<Conductor>> getConductoresDisponibles() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.listaConductoresDisponiblesAPI,
    );
    var response = await client.get(url, headers: requestHeaders);
    final List data = json.decode(response.body);
    return data.map((e) => Conductor.fromJson(e)).toList();
  }

  static Future<RegisterConductorResponseModel> registerConductor(
    RegisterConductorRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.registerConductorAPI,
    );
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    return registerConductorResponseJson(
      response.body,
    );
  }

  static Future<RegisterConductorResponseModel> editarConductor(
    RegisterConductorRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.editarConductorAPI,
    );
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    return registerConductorResponseJson(
      response.body,
    );
  }

  static Future<String> eliminarConductor(cedula) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.eliminarConductorAPI + cedula.toString(),
    );
    var response = await client.delete(url, headers: requestHeaders);
    return response.body;
  }

  static Future<RegisterConductorResponseModel> obtenerUsuario(
    String cedula,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.obtenerUsuarioAPI + cedula,
    );
    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    return registerConductorResponseJson(
      response.body,
    );
  }
}
