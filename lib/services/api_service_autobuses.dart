import 'dart:convert';
import 'package:frontend_flutter/models/autobuses/autobus.dart';
import 'package:frontend_flutter/models/autobuses/registro_autobus_request_model.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/autobuses/registro_autobus_response_model.dart';

class APIServiceAutobuses {
  static var client = http.Client();

  static Future<List<Autobus>> getAutobuses() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.listaAutobusesAPI,
    );
    var response = await client.get(url, headers: requestHeaders);
    final List data = json.decode(response.body);
    return data.map((e) => Autobus.fromJson(e)).toList();
  }

  static Future<List<Autobus>> getAutobusesDisponibles() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.listaAutobusesDisponiblesAPI,
    );
    var response = await client.get(url, headers: requestHeaders);
    final List data = json.decode(response.body);
    return data.map((e) => Autobus.fromJson(e)).toList();
  }

  static Future<RegisterAutobusResponseModel> registerAutobus(
    RegisterAutobusRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.registerAutobusAPI,
    );
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    return registerAutobusResponseJson(
      response.body,
    );
  }

  static Future<RegisterAutobusResponseModel> editarAutobus(
    RegisterAutobusRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.editarAutobusAPI,
    );
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    return registerAutobusResponseJson(
      response.body,
    );
  }

  static Future<String> eliminarAutobus(idautobus) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.parse(
      Config.apiURL + Config.eliminarAutobusAPI + idautobus.toString(),
    );
    var response = await client.delete(url, headers: requestHeaders);
    return response.body;
  }
}
