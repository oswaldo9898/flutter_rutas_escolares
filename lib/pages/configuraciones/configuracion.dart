import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_conductores.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../../config.dart';
import '../../models/login_registro/login_response_model.dart';
import '../../services/api_service_estudiantes.dart';
import '../../services/shared_service.dart';

class Configuracion extends StatefulWidget {
  Configuracion({Key? key}) : super(key: key);

  @override
  State<Configuracion> createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
  late String cedula = '';
  late String cedula2 = '';
  late String nombres = '';
  late String apellidos = '';
  late String email = '';
  late String rol = '';

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  cargarDatos() async {
    LoginResponseModel? usuario = await SharedService.loginDetails();
    cedula = usuario!.data.cedula;
    await APIServiceConductores.obtenerUsuario(cedula).then((value) => {
          nombres = value.data!.nombres,
          apellidos = value.data!.apellidos,
          email = value.data!.email,
        });
  }

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> parametros =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    rol = parametros["rol"];
    cedula2 = parametros["cedula"];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: const Text(
                    'Configuración',
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: ListView(children: <Widget>[
        Container(
            padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
            child: ListTile(
              title: const Text('Cambiar nombre'),
              subtitle: const Text(
                  'Administra tu información personal, esta sección permite cambiar tus nombres y apellidos.'),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.pushNamed(context, '/CambiarNombres', arguments: {
                  'cedula': cedula,
                  'nombres': nombres,
                  'apellidos': apellidos,
                  'email': email,
                }).then((value) => cargarDatos());
              },
            )),
        Container(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: ListTile(
              title: const Text('Cambiar correo electrónico'),
              subtitle: const Text(
                  'Administra tu información personal, esta sección permite cambiar tu correo electrónico.'),
              leading: const Icon(Icons.alternate_email),
              onTap: () {
                Navigator.pushNamed(context, '/CambiarEmail', arguments: {
                  'cedula': cedula,
                  'nombres': nombres,
                  'apellidos': apellidos,
                  'email': email,
                }).then((value) => cargarDatos());
              },
            )),
        Container(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: ListTile(
              title: const Text('Cambiar contraseña'),
              subtitle: const Text(
                  'Administra tu información personal, esta sección permite cambiar tu contraseña.'),
              leading: const Icon(Icons.lock),
              onTap: () {
                Navigator.pushNamed(context, '/CambiarPassword', arguments: {
                  'cedula': cedula,
                }).then((value) => cargarDatos());
              },
            )),
        _EliminarCuentaUI(context, rol, cedula2),
      ]),
    );
  }

  Widget _EliminarCuentaUI(BuildContext context, String rol, String cedula) {
    if (rol == "REPRESENTANTE") {
      return Container(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: ListTile(
            title: const Text('Eliminar cuenta'),
            subtitle: const Text(
                'Recuerda que al eliminar tu cuenta toda tu informacón sera borrada definitivamente.'),
            leading: const Icon(Icons.delete),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(Config.appName),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const [
                            Text('¿Desea eliminar de forma permanente su cuenta?')
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              APIService.eliminarUsuario(cedula)
                                  .then((response) {
                                FormHelper.showSimpleAlertDialog(
                                  context,
                                  Config.appName,
                                  'Su cuenta se ha eliminado exitosamente',
                                  "Aceptar",
                                  () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    SharedService.logout(context);
                                  },
                                );
                              });
                            },
                            child: const Text("Eliminiar")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancelar"))
                      ],
                    );
                  });
            },
          ));
    } else {
      return Container();
    }
  }
}
