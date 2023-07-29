import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:frontend_flutter/services/api_service_rutas.dart';
import 'package:geopoint/geopoint.dart' as GeoPoint;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../config.dart';

class MapaRutaModelo extends ChangeNotifier {
  late GoogleMapController _mapController;
  late Map data;
  final Location _tracker = Location();
  late Circle circle;
  final Set<Marker> _markers = {};
  var locacionesData = [];
  GoogleMapController? get mapController => _mapController;
  Set<Marker> get markers => _markers;
  StreamSubscription? _streamSubscription;
  StreamSubscription<LocationData>? subscription;
  StreamSubscription<QuerySnapshot>? documentSubscription;
  List<conductor>? conductores;
  // Variable para las polyline
  final Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;
  String cedulaConductor = "";
  // Ubicacion de partida
  final LatLng ubicacionEscuela = const LatLng(-1.349583, -80.564389);

  MapaRutaModelo(BuildContext context, int idrutas, String usuario,
      String cedula, String cedulaCond) {
    cedulaConductor = cedula;
    addAllUserMakerToMap(context, idrutas, usuario, cedula, cedulaCond);
  }

  void onMapCreate(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  _crearRuta(context, String usuario, String cedula, String cedulaCond) async {
    await agregarUbicacionEscuela(context);
    await _createPolylines();
    getCurrentLocation(context, usuario, cedula, cedulaCond);
  }

  //Crear los marcadores de cada ubicación en el mapa///////////////////////////
  Future<void> addAllUserMakerToMap(BuildContext context, int idrutas,
      String usuario, String cedula, String cedulaCond) async {
    var allLocaciones = await APIServiceRutas.getEstudiantesRutas(idrutas);
    allLocaciones.forEach(
      (locacion) async {
        await _addMarkerToMap(
            contexto: context,
            identificador: locacion.cedula_est.toString(),
            markerPosition: GeoPoint.GeoPoint(
                latitude: locacion.latitud, longitude: locacion.longitud),
            placeName: locacion.nombres_est + ' ' + locacion.apellidos_est,
            descripcion: obtenerDescripcion('Cédula', locacion.cedula_est),
            cedula: locacion.cedula,
            usuario: usuario);
      },
    );
    await _crearRuta(context, usuario, cedula, cedulaCond);
  }

  //Concatenar la descripción que aparecerá en cada marcador////////////////////
  String obtenerDescripcion(String canton, String parroquia) {
    String descripcion = canton.toString() + ': ' + parroquia.toString();
    return descripcion;
  }

  //Agrega cada una de las ubicación de los estudiantes a las lista de marcadores
  Future<void> _addMarkerToMap(
      {required BuildContext contexto,
      String? identificador,
      required GeoPoint.GeoPoint markerPosition,
      String? placeName,
      String? descripcion,
      String? cedula,
      String? usuario}) async {
    try {
      var points = LatLng(markerPosition.latitude, markerPosition.longitude);
      locacionesData.add(markerPosition);
      _markers.add(Marker(
          markerId: MarkerId(identificador!),
          position: points,
          infoWindow: InfoWindow(
            title: placeName,
            snippet: descripcion,
            onTap: () {
              if (usuario == "CONDUCTOR") {
                showDialog(
                    context: contexto,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(Config.appName),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: const [
                              Text('¿Desea enviar recordatorio de ruta?')
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                APIServiceRutas.enviarNotificaciondispositivo(
                                        cedula,
                                        'Estamos cerca de su domicilio, estar atento.')
                                    .then((value) {});
                                Navigator.of(context).pop();
                              },
                              child: const Text("Enviar")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancelar"))
                        ],
                      );
                    });
              }
            },
          ),
          icon: BitmapDescriptor.defaultMarker));
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    notifyListeners();
  }

  _createPolylines() async {
    late PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];
    for (var i = 1; i <= locacionesData.length; i++) {
      PolylineResult result;
      if (polylineCoordinates.isEmpty) {
        result = await polylinePoints.getRouteBetweenCoordinates(
          "AIzaSyAbmKVSsDQUBR8SpCG1khHFdqHbtaBsrNA", // Google Maps API Key
          PointLatLng(ubicacionEscuela.latitude, ubicacionEscuela.longitude),
          PointLatLng(
              locacionesData[i - 1].latitude, locacionesData[i - 1].longitude),
          travelMode: TravelMode.driving,
        );
      } else {
        result = await polylinePoints.getRouteBetweenCoordinates(
          "AIzaSyAbmKVSsDQUBR8SpCG1khHFdqHbtaBsrNA", // Google Maps API Key
          PointLatLng(
              locacionesData[i - 2].latitude, locacionesData[i - 2].longitude),
          PointLatLng(
              locacionesData[i - 1].latitude, locacionesData[i - 1].longitude),
          travelMode: TravelMode.driving,
        );
      }
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        // ignore: avoid_print
        print(result.status);
      }
    }
    Polyline polyline = Polyline(
      polylineId: const PolylineId('poly'),
      color: Colors.blue,
      points: polylineCoordinates,
      width: 3,
    );
    _polylines.add(polyline);
    notifyListeners();
  }

  //Permite agregar mi ubicación actual en el mapa
  miPosicion(LocationData newLocalData, Uint8List imageData) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: LatLng(newLocalData.latitude!, newLocalData.longitude!),
        tilt: 0,
        zoom: 13.50)));
    updateMarker(newLocalData, imageData);
    //notifyListeners();
  }

  //Crea el marcador de la ubicación catual en el mapa
  updateMarker(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    _markers.add(Marker(
        markerId: const MarkerId("marcador"),
        position: latlng,
        rotation: newLocalData.heading!.toDouble(),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData)));
    circle = Circle(
        circleId: const CircleId("puntero"),
        radius: newLocalData.accuracy!,
        zIndex: 1,
        strokeColor: Colors.blue,
        center: latlng,
        fillColor: Colors.blue.withAlpha(70));
    notifyListeners();
  }

  aggConductor(LatLng newLocalData, Uint8List imageData, String cedula) {
    LatLng latlng = newLocalData;
    _markers.add(Marker(
        markerId: MarkerId(cedula),
        position: latlng,
        // rotation: newLocalData.heading.toDouble(),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData)));
    notifyListeners();
  }

  Future<void> getCurrentLocation(BuildContext context, String usuario,
      String cedula, String cedulaCond) async {
    try {
      var location = await _tracker.getLocation();
      Uint8List imageData = await getMarker(context, 'usuario');
      Uint8List imagenbus = await getMarker(context, 'conductor');
      // updateMarker(location, imageData);
      if (_streamSubscription != null) {
        _streamSubscription!.cancel();
      }
      if (usuario == "CONDUCTOR") {
        subscription ??=
            _tracker.onLocationChanged.listen((LocationData event) {
          if (_mapController != null) {
            _mapController.animateCamera(CameraUpdate.newLatLng(
              LatLng(event.latitude!, event.longitude!),
            ));
          }
          FirebaseFirestore.instance
              .collection("gestionRutas")
              .doc("conductores")
              .collection("rutas")
              .doc(cedula)
              .set({
            'lat': event.latitude,
            'lng': event.longitude,
            'cedulaConductor': cedula
          });
        });
      } else {
        documentSubscription = FirebaseFirestore.instance
            .collection("gestionRutas")
            .doc("conductores")
            .collection("rutas")
            .snapshots()
            .listen((event) {
          conductores = event.docs
              .map((e) =>
                  conductor(e['cedulaConductor'], LatLng(e['lat'], e['lng'])))
              .toList();
          conductores?.forEach((element) {
            if (element.cedula == cedulaCond) {
              aggConductor(element.posicion, imagenbus, element.cedula);
            }
          });
        });
      }
      miPosicion(location, imageData);
      notifyListeners();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (subscription != null) {
      subscription!.cancel();
    }
    if (documentSubscription != null) {
      documentSubscription!.cancel();
    }
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
    }
    FirebaseFirestore.instance
        .collection("gestionRutas")
        .doc("conductores")
        .collection("rutas")
        .doc(cedulaConductor)
        .delete();
  }

  Future<Uint8List> getMarker(BuildContext context, String tipo) async {
    try {
      ByteData byteData;
      if (tipo == 'usuario') {
        byteData = await DefaultAssetBundle.of(context)
            .load("assets/images/cursor.png");
      } else {
        byteData = await DefaultAssetBundle.of(context)
            .load("assets/images/autobus.png");
      }
      notifyListeners();
      return byteData.buffer.asUint8List();
    } catch (e) {
      print(e);
    }
    var byteData;
    return byteData.buffer.asUint8List();
  }

  agregarUbicacionEscuela(BuildContext context) async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/icons/cursor_escuela.png");
    _markers.add(Marker(
        markerId: const MarkerId("marcador2"),
        position: ubicacionEscuela,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(byteData.buffer.asUint8List())));

    notifyListeners();
  }
}

class conductor {
  final String cedula;
  final LatLng posicion;

  conductor(this.cedula, this.posicion);
}
