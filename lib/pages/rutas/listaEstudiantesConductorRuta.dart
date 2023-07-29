import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config.dart';
import '../../view_models/estudianteRutasModelo.dart';

Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  runZoned<Future<void>>(() async {
    runApp(const ListaEstudiantesConductorRutas());
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('catch error=' + error);
}

class ListaEstudiantesConductorRutas extends StatefulWidget {
  const ListaEstudiantesConductorRutas({Key? key}) : super(key: key);

  @override
  State<ListaEstudiantesConductorRutas> createState() => _ListaEstudiantesConductorRutasState();
}

class _ListaEstudiantesConductorRutasState extends State<ListaEstudiantesConductorRutas> {
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
