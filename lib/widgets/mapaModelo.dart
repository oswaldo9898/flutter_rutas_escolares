import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class mapaModelo extends ChangeNotifier {
  late GoogleMapController _mapController;
  late Map data;
  List locacionesData = [];
  GoogleMapController get mapController => _mapController;
  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;
  final Location _tracker = Location();
  late Circle circle;

  void onMapCreate(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  mapaModelo(BuildContext context,  latitud,  longitud) {
    addAllUserMakerToMap(context,latitud,  longitud);
  }

  Future<void> addAllUserMakerToMap(
    BuildContext context,  latitud,  longitud) async {
    await addMarkerToMap(
      contexto: context,
      identificador: "1",
      markerPosition: LatLng( latitud,  longitud),
      placeName: "Mi ubicación",
      descripcion: "Direccion",
    );
  }

  String validarNulos(var campo) {
    if (campo == null) {
      campo = 'No Disponible';
    }
    return campo;
  }

  String obtenerDescripcion(String canton, String parroquia) {
    String descripcion = canton.toString() + ' - ' + parroquia.toString();
    return descripcion;
  }

  Future<void> addMarkerToMap(
      {required BuildContext contexto,
      required String identificador,
      required LatLng markerPosition,
      required String placeName,
      required String descripcion}) async {
    try {
      var points = LatLng(markerPosition.latitude, markerPosition.longitude);
      _markers.add(Marker(
          markerId: MarkerId(identificador),
          position: points,
          infoWindow: InfoWindow(
              title: placeName,
              onTap: () {}),
          icon: BitmapDescriptor.defaultMarker));
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<Uint8List> getMarker(BuildContext context) async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/cursor.png");
    notifyListeners();
    return byteData.buffer.asUint8List();
  }

  updateMarker(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    _markers.add(Marker(
        markerId: const MarkerId("marcador"),
        position: latlng,
        rotation: newLocalData.heading!,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
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

  miPosicion(LocationData newLocalData, Uint8List imageData) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: LatLng(newLocalData.latitude!, newLocalData.longitude!),
        tilt: 0,
        zoom: 14.00)));
    updateMarker(newLocalData, imageData);
    //notifyListeners();
  }

  Future<void> getCurrentLocation(BuildContext context) async {
    try {
      Uint8List imageData = await getMarker(context);
      var location = await _tracker.getLocation();

      updateMarker(location, imageData);
      // if (_streamSubscription != null) {
      //   _streamSubscription.cancel();
      // }

      miPosicion(location, imageData);
      notifyListeners();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }
}
