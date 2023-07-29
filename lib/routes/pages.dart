import 'package:flutter/cupertino.dart';
import 'package:frontend_flutter/pages/autobuses/listaAutobuses.dart';
import 'package:frontend_flutter/pages/conductores/editarConductores.dart';
import 'package:frontend_flutter/pages/conductores/listaConductores.dart';
import 'package:frontend_flutter/pages/conductores/registrarConductores.dart';
import 'package:frontend_flutter/pages/configuraciones/cambiarEmail.dart';
import 'package:frontend_flutter/pages/estudiantes/editarEstudiante.dart';
import 'package:frontend_flutter/pages/estudiantes/listaEstudiantes.dart';
import 'package:frontend_flutter/pages/estudiantes/registrarEstudiante.dart';
import 'package:frontend_flutter/pages/configuraciones/configuracion.dart';
import 'package:frontend_flutter/pages/ingreso/homeRepresentante.dart';
import 'package:frontend_flutter/pages/mapas/mapaRutas.dart';
import 'package:frontend_flutter/pages/verMapa.dart';
import 'package:frontend_flutter/routes/routes.dart';
import '../pages/autobuses/editarAutobus.dart';
import '../pages/autobuses/registrarAutobus.dart';
import '../pages/configuraciones/cambiarNombres.dart';
import '../pages/configuraciones/cambiarPassword.dart';
import '../pages/estudiantes/listaEstudiantesRepresentante.dart';
import '../pages/estudiantes/listaRepresentantes.dart';
import '../pages/estudiantes/representante.dart';
import '../pages/ingreso/homeAdmin.dart';
import '../pages/ingreso/homeConductor.dart';
import '../pages/ingreso/iniciarSesion.dart';
import '../pages/ingreso/registrarse.dart';
import '../pages/rutas/listaAutobusesRutas.dart';
import '../pages/rutas/listaConductoresRutas.dart';
import '../pages/rutas/listaEstudiantesConductorRuta.dart';
import '../pages/rutas/listaEstudiantesRuta.dart';
import '../pages/rutas/listaEstudiantesSinRuta.dart';
import '../pages/rutas/listaRutas.dart';
import '../pages/rutas/listaRutasAdministrador.dart';

abstract class Pages {
  static Map<String, Widget Function(BuildContext)> route = {
    Routes.IniciarSesion: (BuildContext context) => const IniciarSesion(),
    Routes.Registrarse: (BuildContext context) => const Registrarse(),
    Routes.Home: (BuildContext context) => const HomeAdmin(),
    Routes.HomeRepresentante: (BuildContext context) =>const HomeRepresentante(),
    Routes.HomeConductor: (BuildContext context) => HomeConductor(),
    Routes.Configuracion: (BuildContext context) => Configuracion(),
    Routes.CambiarNombres: (BuildContext context) => const CambiarNombres(),
    Routes.CambiarEmail: (BuildContext context) => const CambiarEmail(),
    Routes.CambiarPassword: (BuildContext context) => const CambiarPassword(),

    Routes.verMapa: (BuildContext context) => const VerMapa(),
    Routes.mapaRutas: (BuildContext context) => const MapaRutas(),
    Routes.ListaEstudiantes: (BuildContext context) => const ListaEstudiantes(),
    Routes.RegistrarEstudiante: (BuildContext context) =>const RegistrarEstudiante(),
    Routes.EditarEstudiante: (BuildContext context) => const EditarEstudiante(),
    Routes.Representante: (BuildContext context) => const Representante(),
    Routes.ListaRepresentantes: (BuildContext context) =>const ListaRepresentantes(),
    Routes.ListaEstudiantesRepresentante: (BuildContext context) =>const ListaEstudiantesRepresentante(),
    Routes.ListaAutobuses: (BuildContext context) => const ListaAutobuses(),
    Routes.RegistrarAutobus: (BuildContext context) => const RegistrarAutobus(),
    Routes.EditarAutobus: (BuildContext context) => const EditarAutobus(),
    Routes.ListaConductores: (BuildContext context) => const ListaConductores(),
    Routes.RegistrarConductor: (BuildContext context) =>const RegistrarConductor(),
    Routes.EditarConductor: (BuildContext context) => const EditarConductor(),
    Routes.ListaRutasAdministrador: (BuildContext context) =>const ListaRutasAdministrador(),
    Routes.ListaRutas: (BuildContext context) => const ListaRutas(),
    Routes.ListaAutobusesRutas: (BuildContext context) =>const ListaAutobusesRutas(),
    Routes.ListaConductoresRutas: (BuildContext context) =>const ListaConductoresRutas(),
    Routes.ListaEstudiantesRutas: (BuildContext context) =>const ListaEstudiantesRutas(),
    Routes.ListaEstudiantesConductorRutas: (BuildContext context) =>const ListaEstudiantesConductorRutas(),
    Routes.ListaEstudiantesSinRutas: (BuildContext context) =>        const ListaEstudiantesSinRutas(),
  };
}
