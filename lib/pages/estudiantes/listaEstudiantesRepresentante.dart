import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_estudiantes.dart';
import 'package:provider/provider.dart';
import '../../config.dart';
import '../../view_models/estudianteRepresentanteModelo.dart';

class ListaEstudiantesRepresentante extends StatefulWidget {
  const ListaEstudiantesRepresentante({Key? key}) : super(key: key);

  @override
  State<ListaEstudiantesRepresentante> createState() =>
      _ListaEstudiantesRepresentanteState();
}

class _ListaEstudiantesRepresentanteState
    extends State<ListaEstudiantesRepresentante> {
  String cedula = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> parametros =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    cedula = parametros["cedula"];
    return ChangeNotifierProvider(
        create: (_) => EstudianteRepresentanteModelo(cedula),
        builder: (context, snapshot) {
          var estudianteModelo =
              Provider.of<EstudianteRepresentanteModelo>(context);
          return Scaffold(
              appBar: AppBar(
                title: const Text('Estudiantes'),
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
                                estudianteModelo
                                    .estudiantes[index].apellidos_est),
                            subtitle: Text(
                                estudianteModelo.estudiantes[index].cedula_est),
                            leading: CircleAvatar(
                                child: ClipOval(
                              child: Image.network(
                                // 'http://' +
                                Config.apiURL +
                                    Config.obtenerFotoEstudianteAPI +
                                    estudianteModelo
                                        .estudiantes[index].foto_est,
                                width: 120,
                                height: 120,
                              ),
                            ))),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                  onPressed: () => {
                                        APIService.getRutaEstudiantes(
                                                estudianteModelo
                                                    .estudiantes[index]
                                                    .cedula_est)
                                            .then((value) => {
                                                  Navigator.pushNamed(
                                                      context, '/MapaRutas',
                                                      arguments: {
                                                        'idrutaestudiante':
                                                            value.data!.idrutas,
                                                        'usuario':
                                                            'REPRESENTANTE',
                                                        'cedula': cedula,
                                                        'cedulaConductor':
                                                            value.data!.cedula
                                                      }),
                                                }),
                                      },
                                  child: const Text('Geolocalización')),
                            ]),
                      ]),
                    );
                  }));
        });
  }
}
