import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../../config.dart';
import '../../services/api_service_rutas.dart';
import '../../view_models/estudianteSinRutasModelo.dart';

Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  runZoned<Future<void>>(() async {
    runApp(const ListaEstudiantesSinRutas());
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('catch error=' + error);
}

class ListaEstudiantesSinRutas extends StatefulWidget {
  const ListaEstudiantesSinRutas({Key? key}) : super(key: key);

  @override
  State<ListaEstudiantesSinRutas> createState() =>
      _ListaEstudiantesSinRutasState();
}

class _ListaEstudiantesSinRutasState extends State<ListaEstudiantesSinRutas> {
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  int? idrutas;

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> parametros =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    idrutas = parametros["idrutas"];
    return ChangeNotifierProvider(
      create: (_) => EstudianteSinRutasModelo(),
      builder: (context, snapshot) {
        var estudianteModelo = Provider.of<EstudianteSinRutasModelo>(context);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Estudiantes disponibles'),
              elevation: 0,
            ),
            backgroundColor: Colors.grey[200],
            body: ListView.builder(
                itemCount: estudianteModelo.estudiantes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(5),
                    elevation: 10,
                    child: Column(children: <Widget>[
                      ListTile(
                        title: Text(estudianteModelo
                                .estudiantes[index].nombres_est +
                            ' ' +
                            estudianteModelo.estudiantes[index].apellidos_est),
                        subtitle: Text(
                            estudianteModelo.estudiantes[index].cedula_est),
                        leading: CircleAvatar(
                            child: ClipOval(
                          child: Image.network(
                              Config.apiURL +
                                  Config.obtenerFotoEstudianteAPI +
                                  estudianteModelo.estudiantes[index].foto_est,
                              width: 120,
                              height: 120,
                              fit: BoxFit.fill),
                        )),
                        trailing: IconButton(
                          color: Colors.green,
                          icon: const Icon(Icons.add_circle_outline_outlined),
                          onPressed: () {
                            setState(() {
                              if (estudianteModelo.estudiantes[index].latitud !=
                                      77.0013 &&
                                  estudianteModelo
                                          .estudiantes[index].longitud !=
                                      0.153758) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(Config.appName),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const [
                                              Text(
                                                  '¿Desea agregar al estudiante?')
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                APIServiceRutas
                                                        .registerEstudianteRutas(
                                                            estudianteModelo
                                                                .estudiantes[
                                                                    index]
                                                                .cedula_est,
                                                            idrutas)
                                                    .then((response) {
                                                  FormHelper
                                                      .showSimpleAlertDialog(
                                                    context,
                                                    Config.appName,
                                                    'El estudiante ha sido agregado',
                                                    "Aceptar",
                                                    () {
                                                      estudianteModelo
                                                          .actualizarData();
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  );
                                                });
                                              },
                                              child: const Text("Agregar")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancelar"))
                                        ],
                                      );
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(Config.appName),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const [
                                              Text(
                                                  'Al estudiante aun no se le ha asignado una ubicación valida.'),
                                              Text(
                                                  '¿Desea asignar una ubicación al estudiante?')
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                    ('/ListaEstudiantes')).then((value) => {
                                                      Navigator.of(context).pop(),
                                                      estudianteModelo
                                                          .actualizarData()
                                                    });
                                              },
                                              child: const Text("Asignar")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancelar"))
                                        ],
                                      );
                                    });
                              }
                            });
                          },
                        ),
                      ),
                    ]),
                  );
                }));
      },
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
