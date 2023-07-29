import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend_flutter/models/rutas/registro_rutas_request_model.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../../config.dart';
import '../../services/api_service_rutas.dart';
import '../../view_models/rutaModelo.dart';

Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  runZoned<Future<void>>(() async {
    runApp(const ListaRutasAdministrador());
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('catch error=' + error);
}

class ListaRutasAdministrador extends StatefulWidget {
  const ListaRutasAdministrador({Key? key}) : super(key: key);

  @override
  State<ListaRutasAdministrador> createState() =>
      _ListaRutasAdministradorState();
}

class _ListaRutasAdministradorState extends State<ListaRutasAdministrador> {
  final ruta = TextEditingController();
  late TextEditingController autobus;
  late TextEditingController conductor;
  late String nombreAutobus = 'Sin seleccionar';
  late String nombreconductor = 'Sin seleccionar';

  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    autobus = TextEditingController(text: nombreAutobus);
    conductor = TextEditingController(text: nombreconductor);
    return ChangeNotifierProvider(
      create: (_) => RutaModelo(),
      builder: (context, snapshot) {
        var rutasModelo = Provider.of<RutaModelo>(context);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Rutas'),
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_box_outlined),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _dialoge(context, rutasModelo);
                        });
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            backgroundColor: Colors.grey[200],
            body: ListView.builder(
                itemCount: rutasModelo.rutas.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(5),
                    elevation: 10,
                    child: Column(children: <Widget>[
                      ListTile(
                        title: Text(rutasModelo.rutas[index].nombre),
                        subtitle:
                            Text('Placa: ' + rutasModelo.rutas[index].placa),
                        onTap: () {
                          Navigator.pushNamed(context, '/ListaEstudiantesRutas',
                              arguments: {
                                'idrutaestudiante':
                                    rutasModelo.rutas[index].idrutas,
                              }).then((value) => rutasModelo.actualizarData());
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                              onPressed: () => {
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
                                                            .eliminarRuta(
                                                                rutasModelo
                                                                    .rutas[
                                                                        index]
                                                                    .idrutas)
                                                        .then((response) {
                                                      FormHelper
                                                          .showSimpleAlertDialog(
                                                        context,
                                                        Config.appName,
                                                        'El registro ha sido eliminado',
                                                        "Aceptar",
                                                        () {
                                                          rutasModelo
                                                              .actualizarData();
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      );
                                                    });
                                                  },
                                                  child:
                                                      const Text("Eliminiar")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Cancelar"))
                                            ],
                                          );
                                        })
                                  },
                              child: const Icon(Icons.delete)),
                        ],
                      )
                    ]),
                  );
                }));
      },
    );
  }

  Widget _dialoge(BuildContext context, RutaModelo rutasModelo) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 380,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[200]),
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(children: <Widget>[
                ProgressHUD(
                  child: Form(
                    child: _registrarUI(context, rutasModelo),
                  ),
                  inAsyncCall: isApiCallProcess,
                  opacity: 0.3,
                  key: UniqueKey(),
                ),
              ]),
            )
          ],
        ));
  }

  Widget _registrarUI(BuildContext context, RutaModelo rutasModelo) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            "Datos de la ruta",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            controller: ruta,
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
              labelText: "Nombre Ruta",
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "No puede estar vacio";
              } else {
                return null;
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            controller: autobus,
            enableInteractiveSelection: false,
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.add_box_outlined),
                onPressed: () {
                  _navegarAutobus(context, rutasModelo);
                },
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
              labelText: "Placa autobus",
              labelStyle: const TextStyle(color: Colors.black),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "No puede estar vacio";
              } else {
                return null;
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            controller: conductor,
            enableInteractiveSelection: false,
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.add_box_outlined),
                onPressed: () {
                  _navegarConductor(context, rutasModelo);
                },
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
              labelText: "Cédula conductor",
              labelStyle: const TextStyle(color: Colors.black),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "No puede estar vacio";
              } else {
                return null;
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: FormHelper.submitButton(
            "Guardar",
            () {
              if (conductor.text != "Sin seleccionar" &&
                  autobus.text != "Sin seleccionar" &&
                  ruta.text != "") {
                isApiCallProcess = true;
                RegisterRutasRequestModel model = RegisterRutasRequestModel(
                    cedula: conductor.text,
                    placa: autobus.text,
                    nombre: ruta.text);
                APIServiceRutas.registerRutas(model).then(
                  (response) {
                    setState(() {
                      isApiCallProcess = false;
                    });
                    if (response.message == 'Exito') {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        "Registro exitoso",
                        "Aceptar",
                        () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          rutasModelo.actualizarData();
                        },
                      );
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        response.message,
                        "Aceptar",
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  },
                );
              } else {
                FormHelper.showSimpleAlertDialog(
                  context,
                  Config.appName,
                  "Debe ingresar todos los datos",
                  "Aceptar",
                  () {
                    Navigator.of(context).pop();
                  },
                );
              }
            },
            btnColor: HexColor("283B71"),
            borderColor: Colors.white,
            txtColor: Colors.white,
            borderRadius: 10,
          ),
        ),
      ],
    ));
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _navegarAutobus(BuildContext context, RutaModelo rutasModelo) async {
    final result = await Navigator.pushNamed(
      context,
      ('/ListaAutobusesRutas'),
    );
    Navigator.of(context).pop();
    String resultado = validarVacio(result.toString());
    autobus = TextEditingController(text: resultado);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _dialoge(context, rutasModelo);
      },
    );
  }

  _navegarConductor(BuildContext context, RutaModelo rutasModelo) async {
    final result = await Navigator.pushNamed(
      context,
      ('/ListaConductoresRutas'),
    );
    Navigator.of(context).pop();
    String resultado = validarVacio(result.toString());
    conductor = TextEditingController(text: resultado);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _dialoge(context, rutasModelo);
      },
    );
  }

  String validarVacio(String vacio) {
    if (vacio == 'null') {
      return 'Sin seleccionar';
    }
    return vacio;
  }
}
