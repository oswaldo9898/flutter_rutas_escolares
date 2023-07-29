import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_conductores.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../../config.dart';
import '../../view_models/conductoresDisponiblesModelo.dart';

class ListaConductoresRutas extends StatefulWidget {
  const ListaConductoresRutas({Key? key}) : super(key: key);

  @override
  State<ListaConductoresRutas> createState() => _ListaConductoresRutasState();
}

class _ListaConductoresRutasState extends State<ListaConductoresRutas> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ConductoresDisponiblesModelo(),
        builder: (context, snapshot) {
          var conductoresModelo =
              Provider.of<ConductoresDisponiblesModelo>(context);
          return Scaffold(
              appBar: AppBar(
                title: const Text('Conductores Disponibles'),
                elevation: 0,
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
                          subtitle:
                              Text(conductoresModelo.conductores[index].cedula),
                          leading: CircleAvatar(
                              child: ClipOval(
                            child: Image.network(
                                Config.apiURL +
                                    Config.obtenerFotoConductorAPI +
                                    conductoresModelo.conductores[index].foto,
                                width: 120,
                                height: 120,
                                fit: BoxFit.fill),
                          )),
                          trailing: TextButton(
                            child: const Text("Seleccionar"),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(Config.appName),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const [
                                            Text(
                                                '¿Desea continuar con el proceso?')
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.pop(
                                                  context,
                                                  conductoresModelo
                                                      .conductores[index]
                                                      .cedula);
                                            },
                                            child: const Text("Continuar")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancelar"))
                                      ],
                                    );
                                  });
                            },
                          ),
                        ),
                      ]),
                    );
                  }));
        });
  }
}
