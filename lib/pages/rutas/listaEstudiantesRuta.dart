import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../../config.dart';
import '../../services/api_service_rutas.dart';
import '../../view_models/estudianteRutasModelo.dart';

Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  runZoned<Future<void>>(() async {
    runApp(const ListaEstudiantesRutas());
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('catch error=' + error);
}

class ListaEstudiantesRutas extends StatefulWidget {
  const ListaEstudiantesRutas({Key? key}) : super(key: key);

  @override
  State<ListaEstudiantesRutas> createState() => _ListaEstudiantesRutasState();
}

class _ListaEstudiantesRutasState extends State<ListaEstudiantesRutas> {
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  int? idrutas;

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> parametros =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    idrutas = parametros["idrutaestudiante"];
    return ChangeNotifierProvider(
      create: (_) => EstudianteRutasModelo(idrutas),
      builder: (context, snapshot) {
        var estudianteModelo = Provider.of<EstudianteRutasModelo>(context);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Estudiantes en la ruta'),
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_box_outlined),
                  onPressed: () {
                    Navigator.pushNamed(context, '/ListaEstudiantesSinRutas',
                        arguments: {
                          'idrutas': idrutas,
                        }).then(
                        (value) => estudianteModelo.actualizarData(idrutas));
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
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
                          color: Colors.red,
                          icon: const Icon(Icons.remove_circle_outlined),
                          onPressed: () {
                            setState(() {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(Config.appName),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const [
                                            Text(
                                                '¿Desea eliminar de forma permanente?')
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              APIServiceRutas
                                                      .eliminarEstudianteRuta(
                                                          estudianteModelo
                                                              .estudiantes[
                                                                  index]
                                                              .cedula_est)
                                                  .then((response) {
                                                FormHelper
                                                    .showSimpleAlertDialog(
                                                  context,
                                                  Config.appName,
                                                  'El registro ha sido eliminado',
                                                  "Aceptar",
                                                  () {
                                                    estudianteModelo
                                                        .actualizarData(
                                                            idrutas);
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
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
