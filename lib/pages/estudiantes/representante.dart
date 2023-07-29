import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_estudiantes.dart';
import 'package:frontend_flutter/view_models/representanteAsignado.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../../config.dart';

class Representante extends StatefulWidget {
  const Representante({Key? key}) : super(key: key);

  @override
  State<Representante> createState() => _RepresentanteState();
}

class _RepresentanteState extends State<Representante> {
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? cedulaEst;
  String? cedula;

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> parametros =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    cedulaEst = parametros["cedulaEst"];
    return ChangeNotifierProvider(
      create: (_) => RepresentanteAsignado(cedulaEst),
      builder: (context, snapshot) {
        var estudianteModelo = Provider.of<RepresentanteAsignado>(context);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Representante'),
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_box_outlined),
                  onPressed: () {
                    if (estudianteModelo.representantes.isEmpty) {
                      cedula = "vacio";
                    } else {
                      cedula = estudianteModelo.representantes[0].cedula;
                    }

                    Navigator.pushNamed(context, '/ListaRepresentantes',
                        arguments: {
                          'cedulaEst': cedulaEst,
                          'cedula': cedula,
                        }).then(
                        (value) => estudianteModelo.actualizarData(cedulaEst));
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            backgroundColor: Colors.grey[200],
            body: ListView.builder(
                itemCount: estudianteModelo.representantes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(5),
                    elevation: 10,
                    child: Column(children: <Widget>[
                      ListTile(
                        title: Text(estudianteModelo
                                .representantes[index].nombres +
                            ' ' +
                            estudianteModelo.representantes[index].apellidos),
                        subtitle:
                            Text(estudianteModelo.representantes[index].cedula),
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
                                              APIService
                                                      .eliminarRepresentanteAsignado(
                                                          cedulaEst)
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
                                                            cedulaEst);
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
