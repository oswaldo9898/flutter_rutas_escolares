import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/oneSignal.dart';
import 'package:frontend_flutter/pages/ingreso/homeAdmin.dart';
import 'package:frontend_flutter/pages/ingreso/homeConductor.dart';
import 'package:frontend_flutter/pages/ingreso/homeRepresentante.dart';
import 'package:frontend_flutter/pages/ingreso/iniciarSesion.dart';
import 'package:frontend_flutter/routes/pages.dart';
import 'models/login_registro/login_response_model.dart';
import 'services/shared_service.dart';

Widget _defaultHome = const IniciarSesion();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  // Obtener datos de la cache
  bool _result = await SharedService.isLoggedIn();
  if (_result) {
    LoginResponseModel? usuario = await SharedService.loginDetails();
    if (usuario!.data.rol == "ADMINISTRADOR") {
      _defaultHome = const HomeAdmin();
    } else if (usuario.data.rol == "REPRESENTANTE") {
      _defaultHome = const HomeRepresentante();
    } else if (usuario.data.rol == "CONDUCTOR") {
      _defaultHome = HomeConductor();
    }
  }
  oneSignalInitialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recorrido Seguro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _defaultHome,
      routes: Pages.route,
    );
  }
}
