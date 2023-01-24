import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'dart:async';

class DireccionPage extends StatefulWidget {
  const DireccionPage({super.key});

  @override
  DireccionApp createState() => DireccionApp();
}

const kGoogleApiKey = 'AIzaSyDsa5N3cARyPcI74hKqagXGS2oVSTLXloA';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class DireccionApp extends State<DireccionPage> {
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(-34.1744675, -70.9402657), zoom: 8);

  Set<Marker> markersList = {};
  var direccionEncontrada = [false, ""];

  late GoogleMapController googleMapController;
  final TextEditingController _controladorDireccion = TextEditingController();

  final Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Direccion",
          style: TextStyle(color: Color.fromARGB(255, 255, 79, 52)),
        ),
        backgroundColor: Color.fromARGB(255, 84, 14, 148),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markersList,
            mapType: MapType.hybrid,
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          Padding(
              padding: const EdgeInsets.only(left: 130, top: 300),
              child: direccionEncontrada[0] == true
                  ? ElevatedButton(
                      onPressed: _guardarDireccion,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 84, 14, 148)),
                      child: const Text("Guardar direccion",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 79, 52))))
                  : Container()),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 550, right: 40),
            child: ElevatedButton(
                onPressed: _handlePressButton,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 84, 14, 148)),
                child: const Text("Buscar por direccion",
                    style: TextStyle(color: Color.fromARGB(255, 255, 79, 52)))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 190, top: 550, right: 40),
            child: ElevatedButton(
                onPressed: _obtenerUbicacionActual,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 84, 14, 148)),
                child: const Text("Buscar por ubicacion",
                    style: TextStyle(color: Color.fromARGB(255, 255, 79, 52)))),
          )
        ],
      ),
    );
  }

  //Funcion para obtener ubicacion actual del usuario con geoLocator y mostrarla en el mapa
  Future<void> _obtenerUbicacionActual() async {
    final ubicacion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final latitud = ubicacion.latitude;
    final longitud = ubicacion.longitude;

    final coordenadas = LatLng(latitud, longitud);
    //Obtener direccion mas cercana a la ubicacion actual del usuario y mostrarla en el mapa
    final direcciones = await placemarkFromCoordinates(latitud, longitud,
        localeIdentifier: "es_CL");
    //mostrar direcciones en consola
    print(direcciones[0].street);
    print(direcciones[0].subAdministrativeArea);
    print(direcciones[0].administrativeArea);
    print(direcciones[0].country);
    final cameraPosition = CameraPosition(
      target: coordenadas,
      zoom: 15,
    );

    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    final marker = Marker(
        markerId: MarkerId("ubicacionActual"),
        position: coordenadas,
        infoWindow: InfoWindow(title: "Ubicacion actual"));

    setState(() {
      markersList.add(marker);
    });
  }

  _guardarDireccion() {
    print(direccionEncontrada[1]);
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'es',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Buscar',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [
          Component(Component.country, "usa"),
          Component(Component.country, "cl")
        ]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));

    // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    print(detail.result.name);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));
    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 18.0));
    Timer timer = new Timer(new Duration(seconds: 2), () {
      direccionEncontrada[0] = true;
      direccionEncontrada[1] = detail.result.name;
      setState(() {});
    });
  }
}
