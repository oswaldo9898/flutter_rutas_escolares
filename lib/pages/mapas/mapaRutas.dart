import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../config.dart';
import '../../services/api_service_rutas.dart';
import '../../widgets/mapaRutaModelo.dart';

class MapaRutas extends StatefulWidget {
  const MapaRutas({Key? key}) : super(key: key);

  @override
  State<MapaRutas> createState() => _MapaRutas();
}

class _MapaRutas extends State<MapaRutas> {
  int idrutas = 0;
  String usuario = "";
  String cedula = "";
  String cedulaConductor = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> parametros =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    idrutas = parametros["idrutaestudiante"];
    usuario = parametros["usuario"];
    cedula = parametros["cedula"];
    cedulaConductor = parametros["cedulaConductor"];
    return ChangeNotifierProvider(
        create: (_) =>
            MapaRutaModelo(context, idrutas, usuario, cedula, cedulaConductor),
        builder: (context, snapshot) {
          var mapModel = Provider.of<MapaRutaModelo>(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Ruta asignada'),
            ),
            body: Builder(
              builder: (context) {
                return mapModel.markers.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
                        children: <Widget>[
                          SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: GoogleMap(
                                mapType: MapType.normal,
                                onMapCreated: mapModel.onMapCreate,
                                markers: mapModel.markers,
                                polylines: mapModel.polylines,
                                initialCameraPosition: const CameraPosition(
                                  target: LatLng(-3.459605, -79.957217),
                                  zoom: 5,
                                ),
                                myLocationButtonEnabled: false,
                                myLocationEnabled: true,
                                zoomGesturesEnabled: true,
                                zoomControlsEnabled: false,
                              )),
                        ],
                      );
              },
            ),
            floatingActionButton:
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              _finalizarRecorridoUI(context, usuario),
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton.extended(
                icon: const Icon(Icons.my_location_rounded),
                label: const Text('Mi ubicación'),
                elevation: 5,
                backgroundColor: Colors.blueAccent,
                onPressed: () {
                  mapModel.getCurrentLocation(
                      context, usuario, cedula, cedulaConductor);
                },
                heroTag: null,
              ),
            ]),
          );
        });
  }

  Widget _finalizarRecorridoUI(BuildContext context, usuario) {
    if (usuario == "CONDUCTOR") {
      return FloatingActionButton.extended(
        icon: const Icon(Icons.wrong_location_outlined),
        label: const Text('Finalizar recorrido'),
        elevation: 5,
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(Config.appName),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const [Text('¿Desea finalizar el recorridp?')],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          APIServiceRutas.enviarNotificacionRutas(idrutas,
                                  'El recorrido ha finalizado exitosamente')
                              .then((value) {});
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Finalizar")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancelar"))
                  ],
                );
              });
        },
        heroTag: null,
      );
    } else {
      return Container();
    }
  }
}
