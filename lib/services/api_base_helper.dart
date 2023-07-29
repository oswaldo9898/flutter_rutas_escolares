import 'dart:convert';
import 'package:frontend_flutter/services/app_exceptions.dart';
import 'package:http/http.dart' as http;

dynamic returnResponse(http.Response response) {
  var responseJson = json.decode(response.body);
  switch (response.statusCode) {
    case 200:
      return responseJson;
    case 400:
      throw BadRequestException(responseJson['err']['message']);
    case 401:
    case 403:
      throw UnauthorizedException(responseJson['err']['message']);
    case 404:
      throw NotFoundException(responseJson['err']['message']);
    case 500:
      throw InternalServerException(responseJson['err']['message']);
    case 20201:
      throw InvalidInputException(responseJson['err']['message']);
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
