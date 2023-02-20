// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeemondo/pantallas/user_logeado/Cafeterias.dart';
import 'package:coffeemondo/pantallas/user_logeado/Direccion.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:coffeemondo/pantallas/resenas/crearRese%C3%B1a.dart';
import 'package:coffeemondo/pantallas/user_logeado/resenas.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../firebase/autenticacion.dart';
import '../resenas/resenas.dart';
import 'index.dart';
import 'Perfil.dart';
import 'dart:math' as math;

class EventosDev extends StatefulWidget {
  final String tiempo_inicio;
  const EventosDev(this.tiempo_inicio, {super.key});

  @override
  EventosDevState createState() => EventosDevState();
}

String tab = '';
// Declaracion de variables de informaicon de usuario
String nombre = '';
String nickname = '';
String cumpleanos = '';
String urlImage = '';
num puntaje_actual = 180;
var puntaje_actual_string = puntaje_actual.toStringAsFixed(0);
num puntaje_nivel = 200;
var puntaje_nivel_string = puntaje_nivel.toStringAsFixed(0);
var porcentaje = puntaje_actual / puntaje_nivel;
var nivel = 1;
var niveluser;
var inicio = '';
var contPremio = 0;

// acceso developers

bool acceso_dev = false;
bool abrirCrearCafeteria = false;
TextEditingController nombreEvento = TextEditingController();
TextEditingController tipoEvento = TextEditingController();
TextEditingController fechaEvento = TextEditingController();
TextEditingController direccionEvento = TextEditingController();
TextEditingController correoEvento = TextEditingController();
TextEditingController latitudEvento = TextEditingController();
TextEditingController longitudEvento = TextEditingController();
TextEditingController urlEvento = TextEditingController();
TextEditingController imagenEvento = TextEditingController();

//Crear lista de niveles con sus respectivos datos
List<Map<String, dynamic>> niveles = [
  {'nivel': 1, 'puntaje_nivel': 400, 'porcentaje': 0.0},
  {'nivel': 2, 'puntaje_nivel': 800, 'porcentaje': 0.0},
  {'nivel': 3, 'puntaje_nivel': 1200, 'porcentaje': 0.0},
  {'nivel': 4, 'puntaje_nivel': 1600, 'porcentaje': 0.0},
  {'nivel': 5, 'puntaje_nivel': 2000, 'porcentaje': 0.0},
  {'nivel': 6, 'puntaje_nivel': 2400, 'porcentaje': 0.0},
  {'nivel': 7, 'puntaje_nivel': 2800, 'porcentaje': 0.0},
  {'nivel': 8, 'puntaje_nivel': 3200, 'porcentaje': 0.0},
  {'nivel': 9, 'puntaje_nivel': 3600, 'porcentaje': 0.0},
  {'nivel': 10, 'puntaje_nivel': 4000, 'porcentaje': 0.0},
  {'nivel': 11, 'puntaje_nivel': 4400, 'porcentaje': 0.0},
  {'nivel': 12, 'puntaje_nivel': 4800, 'porcentaje': 0.0},
  {'nivel': 13, 'puntaje_nivel': 5200, 'porcentaje': 0.0},
  {'nivel': 14, 'puntaje_nivel': 5600, 'porcentaje': 0.0},
  {'nivel': 15, 'puntaje_nivel': 6000, 'porcentaje': 0.0},
  {'nivel': 16, 'puntaje_nivel': 6400, 'porcentaje': 0.0},
  {'nivel': 17, 'puntaje_nivel': 6800, 'porcentaje': 0.0},
  {'nivel': 18, 'puntaje_nivel': 7200, 'porcentaje': 0.0},
  {'nivel': 19, 'puntaje_nivel': 7600, 'porcentaje': 0.0},
  {'nivel': 20, 'puntaje_nivel': 8000, 'porcentaje': 0.0},
  {'nivel': 21, 'puntaje_nivel': 8400, 'porcentaje': 0.0},
  {'nivel': 22, 'puntaje_nivel': 8800, 'porcentaje': 0.0},
  {'nivel': 23, 'puntaje_nivel': 9200, 'porcentaje': 0.0},
  {'nivel': 24, 'puntaje_nivel': 9600, 'porcentaje': 0.0},
  {'nivel': 25, 'puntaje_nivel': 10000, 'porcentaje': 0.0},
  {'nivel': 26, 'puntaje_nivel': 10400, 'porcentaje': 0.0},
  {'nivel': 27, 'puntaje_nivel': 10800, 'porcentaje': 0.0},
  {'nivel': 28, 'puntaje_nivel': 11200, 'porcentaje': 0.0},
  {'nivel': 29, 'puntaje_nivel': 11600, 'porcentaje': 0.0},
  {'nivel': 30, 'puntaje_nivel': 12000, 'porcentaje': 0.0},
  {'nivel': 31, 'puntaje_nivel': 12400, 'porcentaje': 0.0},
  {'nivel': 32, 'puntaje_nivel': 12800, 'porcentaje': 0.0},
  {'nivel': 33, 'puntaje_nivel': 13200, 'porcentaje': 0.0},
  {'nivel': 34, 'puntaje_nivel': 13600, 'porcentaje': 0.0},
  {'nivel': 35, 'puntaje_nivel': 14000, 'porcentaje': 0.0},
  {'nivel': 36, 'puntaje_nivel': 14400, 'porcentaje': 0.0},
];
//Crear funcion que retorne en una lista el nivel del usuario y el porcentaje de progreso
List<Map<String, dynamic>> getNivel() {
  var nivel_actual = nivel;
  var nivel_usuario = 0;
  for (var i = 0; i < niveles.length; i++) {
    if (puntaje_actual <= niveles[i]['puntaje_nivel']) {
      nivel_usuario = niveles[i]['nivel'];
      //print('nivel $nivel_usuario');
      porcentaje = (puntaje_actual) / niveles[i]['puntaje_nivel'];
      //Cuando sube de nivel se reinicia el porcentaje
      if (i >= 1) {
        porcentaje =
            (puntaje_actual.toDouble() - niveles[i - 1]['puntaje_nivel']) /
                (niveles[i]['puntaje_nivel'] - niveles[i - 1]['puntaje_nivel']);
        //print((niveles[i]['puntaje_nivel'] - puntaje_actual.toDouble()));
      }

      puntaje_nivel = niveles[i]['puntaje_nivel'];
      break;
    }
  }
  return [
    {
      'nivel': nivel_usuario,
      'porcentaje': porcentaje,
      'puntaje_nivel': puntaje_nivel,
      'nivel actual': nivel_actual
    },
  ];
}

class EventosDevState extends State<EventosDev> {
  // Se declara la instancia de firebase en la variable _firebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late GoogleMapController googleMapController;
  // Si existe un usuario logeado, este asigna a currentUser la propiedad currentUser del Auth de FIREBASE
  User? get currentUser => _firebaseAuth.currentUser;
  @override
  void initState() {
    super.initState();
    // Se inicia la funcion de getData para traer la informacion de usuario proveniente de Firebase
    print('Inicio: ' + widget.tiempo_inicio);
    _getdata();
  }

  bool _visible = false;

  // Mostrar informacion del usuario en pantalla
  void _getdata() async {
    // Se declara en user al usuario actual
    User? user = Auth().currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        // Se setea en variables la informacion recopilada del usuario extraido de los campos de la BD de FireStore
        nombre = userData.data()!['nombre'];
        nickname = userData.data()!['nickname'];
        cumpleanos = userData.data()!['cumpleanos'];
        urlImage = userData.data()!['urlImage'];
        nivel = userData.data()!['nivel'];
        inicio = widget.tiempo_inicio;
        puntaje_actual = int.parse(userData.data()!['puntaje']);
      });
    });
  }

  final DocumentReference docRef =
      FirebaseFirestore.instance.collection("cafeterias").doc();

  XFile? imageFile;
  UploadTask? uploadTask;

  Future subirImagen() async {
    // Se crea la ruta de la imagen en el Storage con el nombre del documento creado en la coleccion
    final path = 'cafeteria_cafeteria_image/${docRef.id}.jpg';
    final file = File(imageFile!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlUserImage = await snapshot.ref.getDownloadURL();

    // Se retorna la url de la imagen para llamarla desde la funcion de guardarInformacion
    return urlUserImage;
  }

  _openGallery(BuildContext context) async {
    //imageFile = await ImagePicker().pickMultiImage();
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        imageFilePath = imageFile!.path;
        imagenSeleccionada = true;
      });
      print('image: $imageFilePath');
    } else {
      imagenSeleccionada = false;
      return;
    }
    //obtener nombre de imagen antes de ser guardada

    setState(() {});
  }

  _openCamera(BuildContext context) async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        imageFilePath = imageFile!.path;
        imagenSeleccionada = true;
      });
      print('image: $imageFilePath');
    } else {
      imagenSeleccionada = false;
      return;
    }
    //obtener nombre de imagen antes de ser guardada

    setState(() {});
  }

  final ImagePicker _picker = ImagePicker();

  Widget FotoPerfil() {
    return ElevatedButton(
      onPressed: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(160),
        child: urlImage != ''
            ? Image.network(
                urlImage,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/user_img.png',
                width: 120,
              ),
      ),
      style: ElevatedButton.styleFrom(shape: CircleBorder()),
    );
  }

  Widget AppBarcus() {
    return Container(
      //darle un ancho y alto al container respecto al tamaño de la pantalla

      height: 200,
      color: Color.fromARGB(0, 0, 0, 0),
      child: Column(
        children: [
          Container(
            height: 160,
            color: Color.fromARGB(255, 84, 14, 148),
          ),
          Container()
        ],
      ),
    );
  }

  @override
  Widget _textoAppBar() {
    return (Text(
      (nickname != 'Sin informacion de nombre de usuario')
          ? (acceso_dev ? "Bienvenido DEV $nickname" : "Bienvenido $nickname")
          : ("Bienvenido anonimo !"),
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    ));
  }

  _subirNivel() async {
    //Se declara en user al usuario actual
    User? user = Auth().currentUser;
    //Se crea una instancia de la base de datos de Firebase
    FirebaseFirestore db = FirebaseFirestore.instance;
    //Se crea una instancia de la coleccion de usuarios
    CollectionReference users = db.collection('users');
    //Se crea una instancia del documento del usuario actual
    DocumentReference documentReference = users.doc(user?.uid);
    //Se actualiza el nivel del usuario
    documentReference.update({'nivel': nivel});
    _subirPuntaje();
  }

  _subirPuntaje() {
    //Se declara en user al usuario actual
    User? user = Auth().currentUser;
    //Se crea una instancia de la base de datos de Firebase
    FirebaseFirestore db = FirebaseFirestore.instance;
    //Se crea una instancia de la coleccion de usuarios
    CollectionReference users = db.collection('users');
    //Se crea una instancia del documento del usuario actual
    DocumentReference documentReference = users.doc(user?.uid);
    //Se actualiza el nivel del usuario
    documentReference.update({'puntaje': puntaje_actual.toString()});
  }

  @override
  Widget _textoProgressBar() {
    //Obtener nivel de getNivel()
    int nivel_usuario = getNivel()[0]['nivel'];
    //Obtener nivel actual de getNivel()
    int nivel_actual = getNivel()[0]['nivel actual'];
    int puntaje_nivel = getNivel()[0]['puntaje_nivel'];
    //print('$nivel_usuario = $nivel_actual');
    //Si el nivel actual es diferente al nivel de usuario, se actualiza el nivel de usuario
    if (nivel_usuario > nivel_actual) {
      nivel = nivel_usuario;
      print('Nivel actualizado: $nivel');
      _subirNivel();
    }
    //Hacer que una funcion se ejecute cada 30 segundos
    Timer.periodic(Duration(seconds: 30), (timer) {
      _subirPuntaje();
      print("puntaje subido a la base de datos {puntaje: $puntaje_actual}");
    });

    return (Row(
      children: [
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.3),
          child: Text(
            'Nivel $nivel_usuario',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          '$puntaje_actual/$puntaje_nivel',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    ));
  }

  @override
  Widget _barraProgressBar() {
    print(porcentaje);
    print(puntaje_actual);
    return (Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
      width: 200,
      height: 25,
      decoration: BoxDecoration(
        color: Color.fromARGB(111, 0, 0, 0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            child: (porcentaje > 0.15)
                ? Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text(
                      '${(porcentaje * 100).toStringAsFixed(0)}%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromARGB(0xff, 0x52, 0x01, 0x9b),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(),
            width: 200 * porcentaje,
            height: 25,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 79, 52),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  Widget _ProgressBar() {
    return (Column(
      children: [
        _textoProgressBar(),
        _barraProgressBar(),
      ],
    ));
  }

  //Funcion para calcular cuanto tiempo lleva el usuario en la aplicacion y actualizar el puntaje
  String _calcularTiempo() {
    //Se obtiene la fecha y hora actual
    var now = new DateTime.now();
    //Se obtiene la fecha y hora de inicio de sesion
    var inicio = DateTime.parse(widget.tiempo_inicio);
    //Se calcula la diferencia entre la fecha y hora actual y la fecha y hora de inicio de sesion
    var diferencia = now.difference(inicio);
    //Se calcula el tiempo en minutos
    var tiempo_hora = diferencia.inHours;
    var tiempo_minutos = diferencia.inMinutes;
    var tiempo_segundos = diferencia.inSeconds;

    return '$tiempo_hora/$tiempo_minutos/$tiempo_segundos';
  }

  @override
  Widget build(BuildContext context) {
    //imprimir el tiempo que lleva el usuario en la aplicacion
    print(_calcularTiempo());

    _recompensa() {
      if (int.parse(_calcularTiempo().split('/')[2]) == 10) {
        print('Recompensa por estar 10 secs en la app, has ganado 10 pts');
        setState(() {
          puntaje_actual += 10;
          porcentaje = puntaje_actual / puntaje_nivel;
          puntaje_actual_string = puntaje_actual.toString();
        });
      }
    }

    @override
    Widget _tituloContainer() {
      return (Text(
        'Felicitaciones!',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ));
    }

    @override
    Widget _cuerpoContainer() {
      return (Text(
        'Enhorabuena! Has subido al nivel $nivel.',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ));
    }

    Widget _containerMensajeNivel() {
      return (AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 1500),
        child: Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          width: MediaQuery.of(context).size.width * 0.9,
          height: (!_visible) ? 0 : MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
            borderRadius: BorderRadius.circular(20),
          ),
          child: //Crear columna que contenga el titulo y el cuerpo del container
              Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: _tituloContainer(),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.04),
                child: _cuerpoContainer(),
              ),
            ],
          ),
        ),
      ));
    }

    Widget _containerMapa() {
      return (Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            color: Color.fromARGB(0, 0, 0, 0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.056,
                  bottom: MediaQuery.of(context).size.height * 0.056,
                ),
                //Mostrar mapa en el container

                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.12,
                    right: MediaQuery.of(context).size.width * 0.12),
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(-33.454572, -70.6559607),
                    zoom: 10,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                  },
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(0, 1, 155, 27),
                ),
              ),
            ],
          )));
    }

    _subirPuntos(int puntos) {
      print(_calcularTiempo());
      //aumentar en 10 el puntaje actual
      setState(() {
        puntaje_actual += puntos;
        porcentaje = puntaje_actual / puntaje_nivel;
        puntaje_actual_string = puntaje_actual.toString();
      });
    }

    Widget btnsDev() {
      return (Container(
        child: Column(children: [
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
            child: ElevatedButton(
              onPressed: () {
                _subirPuntos(10);
              },
              child: Text('Subir puntos'),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => crearResenaPage()));
                ;
              },
              child: Text('Crear resena'),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ResenaPage()));
                ;
              },
              child: Text('Ver resenas'),
            ),
          )
        ]),
      ));
    }

    final Uri _urlBT =
        Uri.parse('https://chat.whatsapp.com/KfA99u7QDyz4mebTEkiMoW');

    Future<void> enviarAlGrupo() async {
      if (!await launchUrl(_urlBT, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $_urlBT');
      }
    }

    final DocumentReference docReCafeteriaf =
        FirebaseFirestore.instance.collection("eventos").doc();

    Future<void> guardarEvento() async {
      User? user = Auth().currentUser;
      if (nombreEvento.text != '') {
        await FirebaseFirestore.instance
            .collection('eventos')
            .where('nombre', isEqualTo: nombreEvento.text)
            .get()
            .then((QuerySnapshot querySnapshot) async {
          if (querySnapshot.docs.isEmpty) {
            print('No existe el evemto');
            docReCafeteriaf.set(({
              'nombre': nombreEvento.text,
              'fecha': fechaEvento.text,
              'creador': user?.uid,
              'correo': correoEvento.text,
              'web': urlEvento.text,
              'ubicacion': direccionEvento.text,
              'imagen': await subirImagen(),
            }));
            print('Ingreso de evento exitoso.');
          } else {
            print('Ya existe el evento');
            setState(() {
              _visible = true;
            });
          }
        });
      } else {
        print('No se ha ingresado un nombre');
        setState(() {
          _visible = true;
        });
      }
    }

    Widget textFieldNombreEvento(TextEditingController controller) {
      return (TextField(
          cursorHeight: 0,
          cursorWidth: 0,
          onTap: () {
            setState(() {});
          },
          controller: controller,
          // onChanged: (((value) => validarCorreo())),
          style: const TextStyle(
            letterSpacing: 2,
            decoration: TextDecoration.none,
            color: Color.fromARGB(255, 255, 79, 52),
            fontSize: 14.0,
            height: 2.0,
            fontWeight: FontWeight.w900,
          ),
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
              ),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.coffee_maker_outlined,
                  color: Color.fromARGB(255, 255, 79, 52), size: 24),
              hintText: 'Nombre del evento',
              hintStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 255, 79, 52),
              ))));
    }

    Widget textFieldFechaEvento(TextEditingController controller) {
      return (TextField(
          cursorHeight: 0,
          cursorWidth: 0,
          onTap: () {
            setState(() {});
          },
          controller: controller,
          // onChanged: (((value) => validarCorreo())),
          style: const TextStyle(
            letterSpacing: 2,
            decoration: TextDecoration.none,
            color: Color.fromARGB(255, 255, 79, 52),
            fontSize: 14.0,
            height: 2.0,
            fontWeight: FontWeight.w900,
          ),
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
              ),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email_outlined,
                  color: Color.fromARGB(255, 255, 79, 52), size: 24),
              hintText: 'Fecha del evento',
              hintStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 255, 79, 52),
              ))));
    }

    Widget textFieldWebEvento(TextEditingController controller) {
      return (TextField(
          cursorHeight: 0,
          cursorWidth: 0,
          onTap: () {
            setState(() {});
          },
          controller: controller,
          // onChanged: (((value) => validarCorreo())),
          style: const TextStyle(
            letterSpacing: 2,
            decoration: TextDecoration.none,
            color: Color.fromARGB(255, 255, 79, 52),
            fontSize: 14.0,
            height: 2.0,
            fontWeight: FontWeight.w900,
          ),
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
              ),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.web_outlined,
                  color: Color.fromARGB(255, 255, 79, 52), size: 24),
              hintText: 'Web del evento',
              hintStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 255, 79, 52),
              ))));
    }

    navegarDireccion() async {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DireccionPage(
                  widget.tiempo_inicio, '', '', '', '', '', 'cr')));
      setState(() {
        direccionEvento.text = result['direccion'];
      });
      print('este es el resultado: $result');
    }

    Widget textFieldUbicacionEvento(TextEditingController controller) {
      return (TextField(
          readOnly: true,
          cursorHeight: 0,
          cursorWidth: 0,
          onTap: () {
            //navegar hacia direccion.dart para obtener la ubicacion de la cafeteria y mostrarla en el campo de texto
            navegarDireccion();
          },
          controller: controller,
          // onChanged: (((value) => validarCorreo())),
          style: const TextStyle(
            letterSpacing: 2,
            decoration: TextDecoration.none,
            color: Color.fromARGB(255, 255, 79, 52),
            fontSize: 14.0,
            height: 2.0,
            fontWeight: FontWeight.w900,
          ),
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
              ),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on_outlined,
                  color: Color.fromARGB(255, 255, 79, 52), size: 24),
              hintText: 'Ubicacion del evento',
              hintStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 255, 79, 52),
              ))));
    }

    Widget textFieldImagenEvento(TextEditingController controller) {
      return (Column(
        children: [
          Container(
            margin:
                EdgeInsets.only(top: (imagenSeleccionada) ? 2 : 15, left: 12),
            child: Row(children: [
              Icon(Icons.image_outlined,
                  color: Color.fromARGB(255, 255, 79, 52), size: 24),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                    (imagenSeleccionada)
                        ? 'Imagen seleccionada'
                        : 'Logo/Imagen del evento',
                    style: TextStyle(
                        letterSpacing: 2,
                        color: Color.fromARGB(255, 255, 79, 52),
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
              Container(
                //Crear widget para mostrar la imagen de imageFile
                margin: EdgeInsets.only(left: 10),
                child: (imagenSeleccionada)
                    ? Image.file(
                        File(imageFilePath),
                        width: 50,
                        height: 50,
                      )
                    : Container(),
              ),
            ]),
          ),
          Container(
            margin: EdgeInsets.only(top: (imagenSeleccionada) ? 4 : 15),
            height: 1,
            color: Color.fromARGB(255, 255, 79, 52),
          )
        ],
      ));
    }

    Widget moduloCrearEvento() {
      return (Container(
        //color: Colors.white,
        margin: EdgeInsets.only(top: (!abrirCrearCafeteria) ? 0 : 15),
        alignment:
            (abrirCrearCafeteria) ? Alignment.topCenter : Alignment.center,
        child: (abrirCrearCafeteria)
            ? Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          abrirCrearCafeteria = false;
                        });
                      },
                      child: Text(
                        'Crear Evento',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 79, 52),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )),
                  Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05),
                      child: textFieldNombreEvento(nombreEvento)),
                  Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05),
                      child: textFieldFechaEvento(correoEvento)),
                  Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05),
                      child: textFieldWebEvento(urlEvento)),
                  Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05),
                      child: textFieldUbicacionEvento(direccionEvento)),
                  Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05),
                      child: GestureDetector(
                        child: textFieldImagenEvento(imagenEvento),
                        onTap: () {
                          _openGallery(context);
                        },
                      )),
                  GestureDetector(
                    onTap: () {
                      guardarEvento;
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 79, 52),
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.04,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                              bottom: MediaQuery.of(context).size.height * 0.02,
                              left: MediaQuery.of(context).size.width * 0.2,
                              right: MediaQuery.of(context).size.width * 0.2),
                          child: Text(
                            'Generar evento',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )),
                  )
                ],
              )
            : Text(
                'Crear Evento',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 79, 52),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
      ));
    }

    Widget containerTazasCalificadas(double promedio) {
      print(promedio);
      return (Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              //color: Colors.white,
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Crear iconos de tazas de acuerdo a la calificacion promedio de la tienda
              Row(
                children: [
                  HalfFilledIcon((promedio >= 1) ? 1 : promedio, Icons.coffee,
                      30, "morado"),
                  HalfFilledIcon((promedio >= 2) ? 1 : promedio - 1,
                      Icons.coffee, 30, "morado"),
                  HalfFilledIcon((promedio >= 3) ? 1 : promedio - 2,
                      Icons.coffee, 30, "morado"),
                  HalfFilledIcon((promedio >= 4) ? 1 : promedio - 3,
                      Icons.coffee, 30, "morado"),
                  HalfFilledIcon((promedio >= 5) ? 1 : promedio - 4,
                      Icons.coffee, 30, "morado"),
                ],
              ),
              Container(
                child: Text(
                  promedio.toString(),
                  style: TextStyle(
                      color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              )
            ],
          )));
    }

    Widget moduloCafeterias(dynamic cafeteria) {
      return (Container(
        child: Text(cafeteria['nombre']),
      ));
    }

    CollectionReference eventos =
        FirebaseFirestore.instance.collection('eventos');

    Widget _bodyEventos() {
      User? user = Auth().currentUser;
      print(user!.uid);
      if (user.uid == '0UqMGUiuqjeMcNVXfcX2Hmp7na72' ||
          user.uid == 'n1OVOWft36cWJrZIn2haHwzXWOJ3' ||
          user.uid == 'zfkeofc6gTgfcUJiUZcnoBYdeNU2') {
        print("Acceso a botones de desarrollo permitido");
        setState(() {
          acceso_dev = true;
        });
      }
      List<String> hoursList = ['00:00', '00:30', '01:00'];
      return (Column(children: [
        _containerMensajeNivel(),
        GestureDetector(
          onTap: () {
            setState(() {
              if (!abrirCrearCafeteria) {
                abrirCrearCafeteria = !abrirCrearCafeteria;
              }
            });
          },
          child: AnimatedContainer(
              width: MediaQuery.of(context).size.width * 0.9,
              height: (abrirCrearCafeteria)
                  ? MediaQuery.of(context).size.height * 0.67
                  : MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
                borderRadius: BorderRadius.circular(20),
              ),
              duration: Duration(seconds: 1),
              child: moduloCrearEvento()),
        ),

        //Crear container para mostrar las cafeterias obtenidas de firebase con la variable cafeterias
        //Container para mostrar las cafeterias
        Container(
          decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Eventos',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: StreamBuilder<QuerySnapshot>(
                  stream: eventos.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Algo salio mal');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Cargando");
                    }

                    return
                        //Crear un ListView.builder para mostrar las cafeterias obtenidas de firebase de forma horizontal
                        ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02),
                                              child: Icon(Icons.coffee_sharp,
                                                  color: Color.fromARGB(
                                                      255, 255, 79, 52)),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.02),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        snapshot.data!.docs[
                                                            index]['nombre'],
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    79,
                                                                    52),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18)),
                                                    Text(
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['ubicacion'],
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 255, 79, 52),
                                                        )),
                                                  ],
                                                ))
                                          ],
                                        )),
                                    Container(
                                      child: Image.network(
                                        snapshot.data!.docs[index]['imagen'],
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        margin: EdgeInsets.only(
                                            top: 5,
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02),
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 79, 52),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Container(
                                            alignment: Alignment(0, 0),
                                            child: Text(
                                              '¡Asistir! ',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0x52, 0x01, 0x9b),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            )),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        margin: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02),
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 79, 52),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Container(
                                            alignment: Alignment(0, 0),
                                            child: Text(
                                              'Visitar Web',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0x52, 0x01, 0x9b),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                  },
                ),
              )
            ]),
          ),
        )
      ]));
    }

    //Hacer que _recompensa se ejecute todo el tiempo
    //Timer.periodic(Duration(seconds: 2), (timer) {
    //_recompensa();
    //});

    //Crear funcion para actualizar el puntaje

    //Crear funcion para detectar cuando el nivel inicial es diferente al nivel actual

    //print(nivel.toString() + ' ' + niveluser.toString());

    return Scaffold(
      backgroundColor: Color(0xffffebdcac),
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170),
        child: Stack(
          children: [
            AppBarcus(),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  child: FotoPerfil(),
                ),
                Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.06),
                        child: _textoAppBar()),
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.055),
                        child:
                            _ProgressBar() //Crear barra de progreso para mostrar el nivel del usuario
                        ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: _bodyEventos(),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}

class HalfCirclePainter extends CustomPainter {
  final Color color;
  final Color fillColor;

  HalfCirclePainter({required this.color, required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    final borderpaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final center = Offset(size.width - 160, size.height * 1.2);
    final radius = (size.width / 2) * 1.5;

    canvas.drawCircle(center, radius, borderpaint);
    canvas.drawCircle(center, radius - 1, fillPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class AppBarcustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarcustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      color: Color.fromARGB(0xff, 0x52, 0x01, 0x9b),
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: BackgroundAppBar(),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 39,
            top: 50,
            child: CustomPaint(
              painter: HalfCirclePainter(
                  color: Color.fromARGB(255, 255, 79, 52),
                  fillColor: Color.fromARGB(0xff, 0x52, 0x01, 0x9b)),
              child: Container(
                width: 65,
                height: 65,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 15,
            child: Center(
              child: Text(
                (nickname != 'Sin informacion de nombre de usuario')
                    ? "Bienvenido al modo Dev $nickname !"
                    : ("Bienvenido anonimo !"),
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 79, 52),
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(150);
}
//CUSTOM APP BAR

//CUSTOM PAINTER APP BAR
class BackgroundAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, 0.0);
    path.moveTo(size.width * 0.2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(BackgroundAppBar oldClipper) => oldClipper != this;
}
//CUSTOM PAINTER APP BAR

//CUSTOM PAINTER BOTTOM BAR
class CustomBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 75,
          color: Colors.transparent,
          child: ClipPath(
              clipper: BackgroundBottomBar(),
              child: Container(
                color: Color.fromARGB(0xff, 0x52, 0x01, 0x9b),
              )),
        ),
        Container(
          height: 70,
          child: GNav(
              backgroundColor: Colors.transparent,
              color: Color.fromARGB(255, 255, 79, 52),
              activeColor: Color.fromARGB(255, 255, 79, 52),
              tabBackgroundColor: Color.fromARGB(50, 0, 0, 0),
              gap: 6,
              selectedIndex: 4,
              padding: EdgeInsets.all(10),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: ' inicio',
                ),
                GButton(
                  icon: Icons.reviews,
                  text: 'Mis Reseñas',
                  onPressed: () {
                    //Exportar la variable tiempo_inicio
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResenasPage(inicio)));
                  },
                ),
                GButton(
                  icon: Icons.event_note_rounded,
                  text: 'Eventos',
                ),
                GButton(
                  icon: Icons.menu_book,
                  text: 'Mis Recetas',
                ),
                GButton(
                  icon: Icons.stars,
                  text: 'Mis logros',
                ),
                GButton(
                    icon: Icons.coffee_maker_outlined,
                    text: 'Cafeterias',
                    onPressed: () {
                      //Exportar la variable tiempo_inicio
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Cafeterias(inicio)));
                    }),
                GButton(
                  icon: Icons.search,
                  text: 'Busqueda',
                ),
                GButton(
                  icon: Icons.account_circle,
                  text: 'Configuracion',
                  //Enlace a vista editar perfil desde Index
                  onPressed: () {
                    //Exportar la variable tiempo_inicio
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PerfilPage(inicio)));
                  },
                ),
              ]),
        ),
      ],
    );
  }
}

class BackgroundBottomBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 59);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
//CUSTOM PAINTER BOTTOM BAR
