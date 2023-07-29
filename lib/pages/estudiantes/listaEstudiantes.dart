import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_estudiantes.dart';
import 'package:frontend_flutter/view_models/estudianteModelo.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../../config.dart';

class ListaEstudiantes extends StatefulWidget {
  const ListaEstudiantes({Key? key}) : super(key: key);

  @override
  State<ListaEstudiantes> createState() => _ListaEstudiantesState();
}

class _ListaEstudiantesState extends State<ListaEstudiantes> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => EstudianteModelo(),
        builder: (context, snapshot) {
          var estudianteModelo = Provider.of<EstudianteModelo>(context);
          return Scaffold(
              appBar: AppBar(
                title: const Text('Estudiantes'),
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.person_add_sharp),
                    onPressed: () {
                      Navigator.pushNamed(context, '/RegistrarEstudiante')
                          .then((value) => {
                                estudianteModelo.actualizarData(),
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(Config.appName),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const [
                                              Text(
                                                  'Recuerde asignarle un representante al nuevo estudiante')
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Aceptar"))
                                        ],
                                      );
                                    })
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
                                estudianteModelo
                                    .estudiantes[index].apellidos_est),
                            subtitle: Text(
                                estudianteModelo.estudiantes[index].cedula_est),
                            leading: CircleAvatar(
                                child: ClipOval(
                              child: Image.network(
                                  Config.apiURL +
                                      Config.obtenerFotoEstudianteAPI +
                                      estudianteModelo
                                          .estudiantes[index].foto_est,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.fill),
                            ))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                                onPressed: () => {
                                      Navigator.pushNamed(context, '/VerMapa',
                                          arguments: {
                                            'cedula_est': estudianteModelo
                                                .estudiantes[index].cedula_est,
                                            'latitud': estudianteModelo
                                                .estudiantes[index].latitud,
                                            'longitud': estudianteModelo
                                                .estudiantes[index].longitud,
                                          }).then((value) =>
                                          estudianteModelo.actualizarData())
                                    },
                                child: const Icon(Icons.add_location_alt)),
                            TextButton(
                                onPressed: () => {
                                      Navigator.pushNamed(
                                          context, '/Representante',
                                          arguments: {
                                            'cedulaEst': estudianteModelo
                                                .estudiantes[index].cedula_est,
                                          })
                                    },
                                child: const Icon(
                                    Icons.supervisor_account_outlined)),
                            TextButton(
                                onPressed: () => {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                insetPadding:
                                                    const EdgeInsets.all(10),
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  alignment: Alignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      width: double.infinity,
                                                      height: 340,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color:
                                                              Colors.grey[200]),
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 50, 20, 20),
                                                      child: Column(
                                                          children: <Widget>[
                                                            ListTile(
                                                              title: const Text(
                                                                  "Cedula "),
                                                              subtitle: Text(
                                                                  estudianteModelo
                                                                      .estudiantes[
                                                                          index]
                                                                      .cedula_est),
                                                            ),
                                                            ListTile(
                                                              title: const Text(
                                                                  "Nombres"),
                                                              subtitle: Text(
                                                                  estudianteModelo
                                                                      .estudiantes[
                                                                          index]
                                                                      .nombres_est),
                                                            ),
                                                            ListTile(
                                                              title: const Text(
                                                                  "Apellidos"),
                                                              subtitle: Text(
                                                                  estudianteModelo
                                                                      .estudiantes[
                                                                          index]
                                                                      .apellidos_est),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: <
                                                                  Widget>[
                                                                TextButton(
                                                                    child: const Text(
                                                                        "Editar"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Navigator.pushNamed(
                                                                          context,
                                                                          '/EditarEstudiante',
                                                                          arguments: {
                                                                            'cedula_est':
                                                                                estudianteModelo.estudiantes[index].cedula_est,
                                                                            'nombres':
                                                                                estudianteModelo.estudiantes[index].nombres_est,
                                                                            'apellidos':
                                                                                estudianteModelo.estudiantes[index].apellidos_est,
                                                                            'foto':
                                                                                estudianteModelo.estudiantes[index].foto_est
                                                                          }).then(
                                                                          (value) =>
                                                                              estudianteModelo.actualizarData());
                                                                    }),
                                                                TextButton(
                                                                    child: const Text(
                                                                        "Cancelar"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    })
                                                              ],
                                                            )
                                                          ]),
                                                    ),
                                                    Positioned(
                                                        top: -100,
                                                        child: Image.network(
                                                          Config.apiURL +
                                                              Config
                                                                  .obtenerFotoEstudianteAPI +
                                                              estudianteModelo
                                                                  .estudiantes[
                                                                      index]
                                                                  .foto_est,
                                                          width: 120,
                                                          height: 120,
                                                        ))
                                                  ],
                                                ));
                                          })
                                    },
                                child: const Icon(Icons.edit)),
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
                                                      APIService.eliminarEstudiante(
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
                                                                .actualizarData();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        );
                                                      });
                                                    },
                                                    child: const Text(
                                                        "Eliminiar")),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child:
                                                        const Text("Cancelar"))
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
        });
  }
}
