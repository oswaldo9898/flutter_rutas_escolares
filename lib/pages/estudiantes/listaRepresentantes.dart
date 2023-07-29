import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_estudiantes.dart';
import 'package:provider/provider.dart';
import '../../config.dart';
import '../../view_models/representantesSinAsignar.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ListaRepresentantes extends StatefulWidget {
  const ListaRepresentantes({Key? key}) : super(key: key);

  @override
  State<ListaRepresentantes> createState() => _ListaRepresentantesState();
}

class _ListaRepresentantesState extends State<ListaRepresentantes> {
  String? cedulaEst;
  String cedula = "vacio";

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> parametros =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    cedulaEst = parametros["cedulaEst"];
    cedula = parametros["cedula"];
    return ChangeNotifierProvider(
      create: (_) => RepresentantesSinAsignar(cedula),
      builder: (context, snapshot) {
        var estudianteModelo = Provider.of<RepresentantesSinAsignar>(context);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Lista de representantes'),
              elevation: 0,
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
                          color: Colors.green,
                          icon: const Icon(Icons.add_circle_outline_outlined),
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
                                                '¿Desea agregar al representante?')
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              APIService
                                                      .registerRepresentantesSinAsignar(
                                                          cedulaEst,
                                                          estudianteModelo
                                                              .representantes[
                                                                  index]
                                                              .cedula)
                                                  .then((response) {
                                                FormHelper
                                                    .showSimpleAlertDialog(
                                                  context,
                                                  Config.appName,
                                                  'El representante ha sido asignado',
                                                  "Aceptar",
                                                  () {
                                                    estudianteModelo
                                                        .actualizarData(
                                                            estudianteModelo
                                                                .representantes[
                                                                    index]
                                                                .cedula);
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
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
}
