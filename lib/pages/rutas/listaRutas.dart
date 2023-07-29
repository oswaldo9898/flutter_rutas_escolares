import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/rutaConductorModelo.dart';

class ListaRutas extends StatefulWidget {
  const ListaRutas({Key? key}) : super(key: key);

  @override
  State<ListaRutas> createState() => _ListaRutasState();
}

class _ListaRutasState extends State<ListaRutas> {
  String cedula = '';
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> parametros =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    cedula = parametros["cedula"];
    return ChangeNotifierProvider(
      create: (_) => RutaConductorModelo(cedula),
      builder: (context, snapshot) {
        var rutasModelo = Provider.of<RutaConductorModelo>(context);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Rutas'),
              elevation: 0,
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
                          onTap: () {},
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/ListaEstudiantesConductorRutas',
                                    arguments: {
                                      'idrutaestudiante':
                                          rutasModelo.rutas[index].idrutas,
                                    }).then((value) =>
                                    rutasModelo.actualizarData(cedula));
                              },
                              color: Colors.blue,
                              icon: const Icon(Icons.info_outlined))),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              onPressed: () => {
                                Navigator.pushNamed(context, '/MapaRutas',
                                    arguments: {
                                      'idrutaestudiante':
                                          rutasModelo.rutas[index].idrutas,
                                      'usuario':
                                        'CONDUCTOR',
                                      'cedula': cedula,
                                      'cedulaConductor': cedula
                                    }),
                              },
                              child: const Text('Inciar Recorrido'),
                            ),
                          ]),
                    ]),
                  );
                }));
      },
    );
  }
}
