class Config {
  static const String appName = "Recorrido Seguro";
  // static const String apiURL = 'http://192.168.120.1:3000'; //DEV_URL
  static const String apiURL =
      'https://rutas-seguimeinto-app-69d6b32bee49.herokuapp.com'; //PROD_URL HEROKU
  // static const String apiURL =
  //     'http://api-seguimiento-sebastian.us-3.evennode.com'; //PROD_URL evennode
  static const String validarEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const String validarPassword =
      r'^(?=\w*\d)(?=\w*[A-Z])(?=\w*[a-z])\S{8,16}$';

  /////////////////////////LOGIN-REGISTRO////////////////////////
  static const loginAPI = "/api/login";
  static const registerAPI = "/api/registro";

  /////////////////////////USUARIO////////////////////////
  static const obtenerUsuarioAPI = "/api/obtener_usuario/";
  static const cambiarPasswordAPI = "/api/cambiar_password";
  static const eliminarUsuarioAPI = "/api/eliminar_usuario_representante/";

  ////////////////////////ESTUDIANTES///////////////////////////////////
  static const registerEstudianteAPI = "/api/registro_estudiante";
  static const listaEstudiantesAPI = "/api/lista_estudiantes";
  static const listaEstudiantesRepresentanteAPI =
      "/api/lista_estudiantes_representante/";
  static const obtenerFotoEstudianteAPI = "/api/obtener_foto_estudiante/";
  static const registroEstudianteDireccionAPI =
      "/api/registro_estudiante_direccion";
  static const editarEstudianteAPI = "/api/editar_estudiante";
  static const eliminarEstudianteAPI = "/api/eliminar_estudiante/";
  static const cantidadEstudianteAPI = "/api/cantidad_estudiantes";
  static const representantesSinAsignarAPI =
      "/api/obtener_representante_libre/";
  static const representanteAsignadoAPI =
      "/api/obtener_representante_asignado/";
  static const registerRepresentanteAPI = "/api/registro_representante/";
  static const eliminarRepresentanteAsignadoAPI =
      "/api/eliminar_representante_asignado/";
  static const registerIdRepresentanteAPI = "/api/registrar_id_activo/";
  static const eliminarIdRepresentanteAPI = "/api/eliminar_id_activo/";
  static const obtenerRutaEstudianteAPI = "/api/obtener_idruta_estudiante/";

  ////////////////////////AUTOBUSES///////////////////////////////////
  static const registerAutobusAPI = "/api/registro_autobus";
  static const listaAutobusesAPI = "/api/lista_autobuses";
  static const listaAutobusesDisponiblesAPI =
      "/api/lista_autobuses_disponibles";
  static const obtenerFotoAutobusAPI = "/api/obtener_foto_autobus/";
  static const editarAutobusAPI = "/api/editar_autobus";
  static const eliminarAutobusAPI = "/api/eliminar_autobus/";

  ////////////////////////CONDUCTORES///////////////////////////////////
  static const registerConductorAPI = "/api/registro_conductor";
  static const listaConductoresAPI = "/api/lista_conductores";
  static const listaConductoresDisponiblesAPI =
      "/api/lista_conductores_disponibles";
  static const obtenerFotoConductorAPI = "/api/obtener_foto_conductor/";
  static const editarConductorAPI = "/api/editar_conductor";
  static const eliminarConductorAPI = "/api/eliminar_conductor/";

  ////////////////////////RUTAS///////////////////////////////////
  static const registerRutaAPI = "/api/registro_ruta";
  static const listaRutasAPI = "/api/lista_rutas";
  static const listaRutasConductorAPI = "/api/lista_rutas_conductor/";
  static const eliminarRutaAPI = "/api/eliminar_ruta/";
  static const listaEstudiantesSinRutasAPI =
      "/api/obtener_estudiantes_sin_ruta";
  static const listaEstudiantesRutasAPI = "/api/obtener_estudiantes_ruta/";
  static const eliminarEstudianteRutaAPI = "/api/eliminar_estudiantes_ruta/";
  static const registerEstudianteRutaAPI = "/api/registro_estudiante_ruta/";
  static const cantidadRutaAPI = "/api/cantidad_rutas";
  static const notificacionDispositivoAPI =
      "/api/enviar_notificacion_dispotivo/";
  static const notificacionRutasAPI = "/api/enviar_notificacion_rutas/";
}
