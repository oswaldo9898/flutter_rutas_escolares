import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_rutas.dart';
import 'package:frontend_flutter/widgets/menuLateral.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/api_service_estudiantes.dart';
import '../../view_models/estudianteModelo.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  static String id = 'home';

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int cantEstudiantes = 0;
  int cantRutas = 0;
  late String cedula = '';
  late String nombres = '';

  @override
  void initState() {
    super.initState();
    APIServiceRutas.cantidadRutas().then((response) {
      cantRutas = response;
      
    });
    _obtenerRutasEstudiantes();
  }

  _obtenerRutasEstudiantes() async {
    APIService.cantidadEstudiantes().then((response) {
      cantEstudiantes = response;
    });
  }

  final List roomAssets = [
    {
      "icon": "assets/icons/rutas.png",
      "title": "Rutas",
      "subTitle": "Rutas disponibles",
      "ruta": "/ListaRutasAdministrador",
      "isActive": true
    },
    {
      "icon": "assets/icons/student.png",
      "title": "Estudiantes",
      "subTitle": "Estudiantes registrados",
      "ruta": "/ListaEstudiantes",
      "isActive": true
    },
    {
      "icon": "assets/icons/conductor.png",
      "title": "Conductores",
      "subTitle": "Conductores registrados",
      "ruta": "/ListaConductores",
      "isActive": true
    },
    {
      "icon": "assets/icons/bus.png",
      "title": "Autobuses",
      "subTitle": "Autobuses disponibles",
      "ruta": "/ListaAutobuses",
      "isActive": true
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => EstudianteModelo(),
        builder: (context, snapshot) {
          var estudianteModelo = Provider.of<EstudianteModelo>(context);
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Inicio'),
                elevation: 0,
              ),
              backgroundColor: Colors.grey[200],
              drawer: MenuLateral('Home'),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 220,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      decoration: const BoxDecoration(
                        color: Color(0xFF3493FF),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Seguimiento de rutas',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Recuerde estar en constante comunicación con sus hijos',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white70,
                                    child:
                                        Image.asset('assets/icons/student.png'),
                                    radius: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        cantEstudiantes.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        'Estudiantes',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white70,
                                    child: Image.asset('assets/icons/road.png'),
                                    radius: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        cantRutas.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        'Rutas',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: roomAssets.length,
                          itemBuilder: (_, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              height: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black54,
                                        offset: Offset(3, 5),
                                        blurRadius: 9,
                                        spreadRadius: 1)
                                  ]),
                              child: ListTile(
                                leading: Image.asset(roomAssets[index]['icon']),
                                title: Text(roomAssets[index]['title']),
                                subtitle: Text(roomAssets[index]['subTitle']),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, (roomAssets[index]['ruta']));
                                },
                                trailing: const Icon(
                                    Icons.keyboard_arrow_right_outlined),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> initPlatform() async {
    await OneSignal.shared.setAppId("");
    await OneSignal.shared.getDeviceState().then((value) => {});
  }
}
