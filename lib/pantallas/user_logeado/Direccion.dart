import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:coffeemondo/pantallas/user_logeado/Info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'dart:async';

class DireccionPage extends StatefulWidget {
  final String inicio;
  final String nombre_apellido;
  final String nombre_usuario;
  final String edad;
  final String telefono;
  final String direccion;
  final String origen;
  const DireccionPage(this.inicio, this.nombre_apellido, this.nombre_usuario,
      this.edad, this.telefono, this.direccion, this.origen,
      {super.key});

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
  late Marker markerDireccion;

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
            //Si direccionencontrada 0 es true, no se puede mover el mapa
            scrollGesturesEnabled: direccionEncontrada[0] == false,
            zoomGesturesEnabled: direccionEncontrada[0] == false,
            initialCameraPosition: initialCameraPosition,
            markers: markersList,
            mapType: MapType.hybrid,
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          Container(
              //colocar container un poco mas abajo del centro de la pantalla
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2),
              alignment: Alignment.center,
              child: direccionEncontrada[0] == true
                  ? //generar columna con boton guardar direccion y otro boton con el icono de cerrar
                  Column(
                      //centrar columna de forma vertical y horizontal
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          ElevatedButton(
                              onPressed: _guardarDireccion,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 84, 14, 148)),
                              child: Text(direccionEncontrada[1].toString(),
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 79, 52)))),
                          ElevatedButton(
                              onPressed: _guardarDireccion,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 84, 14, 148)),
                              child: const Text("Guardar direccion",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 79, 52)))),
                          ElevatedButton(
                              onPressed: () {
                                //cambiar estado de direccionEncontrada a false
                                setState(() {
                                  direccionEncontrada[0] = false;
                                  markersList.clear();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 84, 14, 148)),
                              child: const Icon(Icons.close,
                                  color: Color.fromARGB(255, 255, 79, 52)))
                        ])
                  : Container()),
          //crear elevated button que sea responsive y que se ubique en la parte inferior izquierda de la pantalla y que al presionarlo se abra el buscador de direcciones
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.005,
              top: MediaQuery.of(context).size.height * 0.80,
            ),
            child: ElevatedButton(
                onPressed: _handlePressButton,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 84, 14, 148)),
                child: const Text("Buscar por direccion",
                    style: TextStyle(color: Color.fromARGB(255, 255, 79, 52)))),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.43,
              top: MediaQuery.of(context).size.height * 0.80,
            ),
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

  //funcion mostrar marcadore en el mapa
  void _mostrarMarcador(Marker marker) {
    setState(() {
      markersList.add(marker);
    });
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
    direccionEncontrada[0] = true;
    direccionEncontrada[1] = direcciones[0].street.toString();
    print(direccionEncontrada);
    //mostrar direcciones en consola
    print(direcciones[0].street);
    print(direcciones[0].subAdministrativeArea);
    print(direcciones[0].administrativeArea);
    print(direcciones[0].country);
    final cameraPosition = CameraPosition(
      target: coordenadas,
      zoom: 18,
    );

    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    final marker = setState(() {
      markerDireccion = Marker(
          markerId: const MarkerId("0"),
          position: coordenadas,
          infoWindow: InfoWindow(title: direccionEncontrada[1].toString()));
    });
    print(markerDireccion.position);
    _mostrarMarcador(markerDireccion);
  }

  _guardarDireccion() {
    print(direccionEncontrada[1]);
    if (widget.origen == 'ip') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => InfoPage(
                  widget.inicio,
                  widget.nombre_apellido,
                  widget.nombre_usuario,
                  widget.edad,
                  widget.telefono,
                  direccionEncontrada[1].toString())));
    } else if (widget.origen == 'cr') {
      Navigator.pop(context, {
        'direccion': direccionEncontrada[1].toString(),
        'latitud': markerDireccion.position.latitude,
        'longitud': markerDireccion.position.longitude
      });
    }
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
        components: [Component(Component.country, "cl")]);

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

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    //Si direccionEncontrada[0] es false, dejar de mostrar el marcador de la ubicacion actual del usuario

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 18.0));
    Timer timer = new Timer(new Duration(seconds: 2), () {
      direccionEncontrada[0] = true;
      //Separar formattedAddress en calle, comuna y region con un split y mostrarlo en el mapa
      var direccion_string = detail.result.formattedAddress.toString();
      var direccion_separada = direccion_string.split(",");
      var region = direccion_separada[1].split(' ');
      print(region.toString() + " " + region.length.toString());
      if (region.length == 3) {
        direccion_string = direccion_separada[0] + ", " + region[2];
      } else if (region.length > 3) {
        direccion_string = direccion_separada[0] + ',';
        for (int i = 2; i < region.length; i++) {
          direccion_string += ' ' + region[i];
        }
      } else if (region.length < 3) {
        direccion_string = direccion_separada[0] + ", " + region[1];
      }

      print(direccion_string);
      direccionEncontrada[1] = direccion_string;
      setState(() {});
      print('esto pasa: ' + direccion_string);
      setState(() {
        markerDireccion = Marker(
            markerId: const MarkerId("0"),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: direccion_string));
      });
      print(markerDireccion.position);
      _mostrarMarcador(markerDireccion);
    });
  }
}
