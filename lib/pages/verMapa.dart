import 'package:flutter/material.dart';
import 'package:frontend_flutter/models/estudiantes/estudiante_direccion.dart';
import 'package:frontend_flutter/services/api_service_estudiantes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../config.dart';
import '../widgets/mapaModelo.dart';

class VerMapa extends StatefulWidget {
  const VerMapa({Key? key}) : super(key: key);

  @override
  State<VerMapa> createState() => _VerMapaState();
}

class _VerMapaState extends State<VerMapa> {
  String? cedula_est = '';
  double? latitud = 0;
  double? longitud = 0;

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> parametros =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    cedula_est = parametros["cedula_est"];
    latitud = parametros["latitud"];
    longitud = parametros["longitud"];
    return ChangeNotifierProvider(
        create: (_) => mapaModelo(context, latitud, longitud),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Ubicación de domicilio',
                ),
              ),
              body: Builder(builder: (context) {
                final mapModel = Provider.of<mapaModelo>(context);
                return Scaffold(
                    body: Builder(
                      builder: (context) {
                        return Stack(
                          children: <Widget>[
                            SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  onMapCreated: mapModel.onMapCreate,
                                  markers: mapModel.markers,
                                  onTap: (position) {
                                    latitud = position.latitude;
                                    longitud = position.longitude;
                                    mapModel.addMarkerToMap(
                                      contexto: context,
                                      identificador: "1",
                                      markerPosition: position,
                                      placeName: "Dirección del estudiante",
                                      descripcion: "descripcion",
                                    );
                                  },
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
                    floatingActionButton: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton.extended(
                            icon: const Icon(Icons.save_alt),
                            label: const Text('Guardar'),
                            elevation: 5,
                            backgroundColor: Colors.blueAccent,
                            onPressed: () {
                              if (latitud != 0 && longitud != 0) {
                                EstudianteDireccion model = EstudianteDireccion(
                                    cedula_est!, latitud!, longitud!);
                                APIService.registerEstudianteDirecion(model)
                                    .then((response) {
                                  Navigator.of(context).pop();
                                });
                              } else {
                                FormHelper.showSimpleAlertDialog(
                                  context,
                                  Config.appName,
                                  "Seleccione un punto en el mapa",
                                  "Aceptar",
                                  () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              }
                            },
                            heroTag: null,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FloatingActionButton.extended(
                            icon: const Icon(Icons.my_location_rounded),
                            label: const Text('Mi ubicación'),
                            elevation: 5,
                            backgroundColor: Colors.blueAccent,
                            onPressed: () {
                              mapModel.getCurrentLocation(context);
                            },
                            heroTag: null,
                          ),
                        ]));
              }));
        });
  }
}
