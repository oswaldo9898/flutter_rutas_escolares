import 'package:flutter/material.dart';
import 'package:frontend_flutter/view_models/autobusDisponiblesModelo.dart';
import 'package:provider/provider.dart';
import '../../config.dart';

class ListaAutobusesRutas extends StatefulWidget {
  const ListaAutobusesRutas({Key? key}) : super(key: key);

  @override
  State<ListaAutobusesRutas> createState() => _ListaAutobusesRutasState();
}

class _ListaAutobusesRutasState extends State<ListaAutobusesRutas> {
  bool isSwitched = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AutobusDisponiblesModelo(),
        builder: (context, snapshot) {
          var autobusModelo = Provider.of<AutobusDisponiblesModelo>(context);
          return Scaffold(
              appBar: AppBar(
                title: const Text('Autobuses Disponibles'),
                elevation: 0,
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
                          subtitle: Text(autobusModelo.autobuses[index].placa),
                          leading: CircleAvatar(
                              child: ClipOval(
                            child: Image.network(
                                Config.apiURL +
                                    Config.obtenerFotoAutobusAPI +
                                    autobusModelo.autobuses[index].foto,
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
                                                  autobusModelo
                                                      .autobuses[index].placa);
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
