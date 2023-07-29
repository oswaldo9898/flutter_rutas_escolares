import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_conductores.dart';
import 'package:frontend_flutter/view_models/conductorModelo.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../../config.dart';

class ListaConductores extends StatefulWidget {
  const ListaConductores({Key? key}) : super(key: key);

  @override
  State<ListaConductores> createState() => _ListaConductoresState();
}

class _ListaConductoresState extends State<ListaConductores> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ConductorModelo(),
        builder: (context, snapshot) {
          var conductoresModelo = Provider.of<ConductorModelo>(context);
          return Scaffold(
              appBar: AppBar(
                title: const Text('Conductores'),
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add_box_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, '/RegistrarConductor')
                          .then((value) => conductoresModelo.actualizarData());
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              backgroundColor: Colors.grey[200],
              body: ListView.builder(
                  itemCount: conductoresModelo.conductores.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(5),
                      elevation: 10,
                      child: Column(children: <Widget>[
                        ListTile(
                            title: Text(conductoresModelo
                                    .conductores[index].nombres +
                                ' ' +
                                conductoresModelo.conductores[index].apellidos),
                            subtitle: Text(
                                conductoresModelo.conductores[index].cedula),
                            leading: CircleAvatar(
                                child: ClipOval(
                              child: Image.network(
                                  // 'http://' +
                                  Config.apiURL +
                                      Config.obtenerFotoConductorAPI +
                                      conductoresModelo.conductores[index].foto,
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
                                                                  "Cédula "),
                                                              subtitle: Text(
                                                                  conductoresModelo
                                                                      .conductores[
                                                                          index]
                                                                      .cedula),
                                                            ),
                                                            ListTile(
                                                              title: const Text(
                                                                  "Nombres"),
                                                              subtitle: Text(
                                                                  conductoresModelo
                                                                      .conductores[
                                                                          index]
                                                                      .nombres),
                                                            ),
                                                            ListTile(
                                                              title: const Text(
                                                                  "Apellidos"),
                                                              subtitle: Text(
                                                                  conductoresModelo
                                                                      .conductores[
                                                                          index]
                                                                      .apellidos),
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
                                                                          '/EditarConductor',
                                                                          arguments: {
                                                                            'cedula':
                                                                                conductoresModelo.conductores[index].cedula,
                                                                            'nombres':
                                                                                conductoresModelo.conductores[index].nombres,
                                                                            'apellidos':
                                                                                conductoresModelo.conductores[index].apellidos,
                                                                            'email':
                                                                                conductoresModelo.conductores[index].email,
                                                                            'foto':
                                                                                conductoresModelo.conductores[index].foto
                                                                          }).then(
                                                                          (value) =>
                                                                              conductoresModelo.actualizarData());
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
                                                                .obtenerFotoConductorAPI +
                                                            conductoresModelo
                                                                .conductores[
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
                                                      APIServiceConductores
                                                              .eliminarConductor(
                                                                  conductoresModelo
                                                                      .conductores[
                                                                          index]
                                                                      .cedula)
                                                          .then((response) {
                                                        FormHelper
                                                            .showSimpleAlertDialog(
                                                          context,
                                                          Config.appName,
                                                          'El registro ha sido eliminado',
                                                          "Aceptar",
                                                          () {
                                                            conductoresModelo
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
