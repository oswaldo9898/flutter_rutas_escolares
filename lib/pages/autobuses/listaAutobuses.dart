import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_autobuses.dart';
import 'package:frontend_flutter/view_models/autobusModelo.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../../config.dart';

class ListaAutobuses extends StatefulWidget {
  const ListaAutobuses({Key? key}) : super(key: key);

  @override
  State<ListaAutobuses> createState() => _ListaAutobusesState();
}

class _ListaAutobusesState extends State<ListaAutobuses> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AutobusModelo(),
        builder: (context, snapshot) {
          var autobusModelo = Provider.of<AutobusModelo>(context);
          return Scaffold(
              appBar: AppBar(
                title: const Text('Autobuses'),
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add_box_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, '/RegistrarAutobus')
                          .then((value) => autobusModelo.actualizarData());
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              backgroundColor: Colors.grey[200],
              body: ListView.builder(
                  itemCount: autobusModelo.autobuses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(5),
                      elevation: 10,
                      child: Column(children: <Widget>[
                        ListTile(
                            title: Text(autobusModelo.autobuses[index].marca +
                                ' ' +
                                autobusModelo.autobuses[index].modelo),
                            subtitle:
                                Text(autobusModelo.autobuses[index].placa),
                            leading: CircleAvatar(
                                child: ClipOval(
                              child: Image.network(
                                  // 'http://' +
                                  Config.apiURL +
                                      Config.obtenerFotoAutobusAPI +
                                      autobusModelo.autobuses[index].foto,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.fill),
                            ))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
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
                                                                  "Marca "),
                                                              subtitle: Text(
                                                                  autobusModelo
                                                                      .autobuses[
                                                                          index]
                                                                      .marca),
                                                            ),
                                                            ListTile(
                                                              title: const Text(
                                                                  "Modelo"),
                                                              subtitle: Text(
                                                                  autobusModelo
                                                                      .autobuses[
                                                                          index]
                                                                      .modelo),
                                                            ),
                                                            ListTile(
                                                              title: const Text(
                                                                  "Placa"),
                                                              subtitle: Text(
                                                                  autobusModelo
                                                                      .autobuses[
                                                                          index]
                                                                      .placa),
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
                                                                          '/EditarAutobus',
                                                                          arguments: {
                                                                            'idautobus':
                                                                                autobusModelo.autobuses[index].idautobus,
                                                                            'marca':
                                                                                autobusModelo.autobuses[index].marca,
                                                                            'modelo':
                                                                                autobusModelo.autobuses[index].modelo,
                                                                            'placa':
                                                                                autobusModelo.autobuses[index].placa,
                                                                            'foto':
                                                                                autobusModelo.autobuses[index].foto
                                                                          }).then(
                                                                          (value) =>
                                                                              autobusModelo.actualizarData());
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
                                                                .obtenerFotoAutobusAPI +
                                                            autobusModelo
                                                                .autobuses[
                                                                    index]
                                                                .foto,
                                                        width: 120,
                                                        height: 120,
                                                      ),
                                                    )
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
                                                      APIServiceAutobuses
                                                              .eliminarAutobus(
                                                                  autobusModelo
                                                                      .autobuses[
                                                                          index]
                                                                      .idautobus)
                                                          .then((response) {
                                                        FormHelper
                                                            .showSimpleAlertDialog(
                                                          context,
                                                          Config.appName,
                                                          'El registro ha sido eliminado',
                                                          "Aceptar",
                                                          () {
                                                            autobusModelo
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
