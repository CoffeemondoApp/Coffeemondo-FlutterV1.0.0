import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeemondo/pantallas/user_logeado/Eventos.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:coffeemondo/pantallas/resenas/crearRese%C3%B1a.dart';
import 'package:coffeemondo/pantallas/user_logeado/resenas.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../firebase/autenticacion.dart';
import '../resenas/resenas.dart';
import 'Cafeterias.dart';
import 'Eventos.dart';
import 'Perfil.dart';
import 'dart:math' as math;

class IndexPage extends StatefulWidget {
  final String tiempo_inicio;
  const IndexPage(this.tiempo_inicio, {super.key});

  @override
  IndexPageState createState() => IndexPageState();
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
var colorScaffold = Color(0xffffebdcac);

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

class IndexPageState extends State<IndexPage> {
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
          ? "Bienvenido $nickname !"
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
    print('$nivel_usuario = $nivel_actual');
    //Si el nivel actual es diferente al nivel de usuario, se actualiza el nivel de usuario
    if (nivel_usuario > nivel_actual) {
      nivel = nivel_usuario;
      print('Nivel actualizado: $nivel');
      _subirNivel();
    }
    //Hacer que una funcion se ejecute cada 30 segundos
    Timer.periodic(Duration(seconds: 30), (timer) {
      _subirPuntaje();
    });

    return (Container(
        width: MediaQuery.of(context).size.width * 0.6,
        //color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nivel $nivel',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text(
                '$puntaje_actual/$puntaje_nivel',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )));
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

    Widget _bodyIndex() {
      return (Column(
        children: [
          _containerMensajeNivel(),
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              //color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: Text('Bienvenido a la Beta !!!',
                      style: TextStyle(
                          color: morado,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Text(
                              'En esta versión de la aplicación, podrás ver las reseñas de los cafes que visitas y subir tus propias reseñas. Además, podrás ver el puntaje de los lugares que visitas y el puntaje de los lugares que has visitado.',
                              style: TextStyle(
                                  color: morado,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                                'Felicitaciones! Fuiste seleccionado como Beta Tester, eres uno de los primeros usuarios y por eso te damos un premio de 500 puntos. ¡Disfruta de la aplicación!',
                                style: TextStyle(
                                    color: morado,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (contPremio < 3) {
                                        _subirPuntos(500);

                                        setState(() {
                                          contPremio++;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      decoration: BoxDecoration(
                                          color: morado,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        child: Center(
                                          child: Text(
                                            'Obtener premio :D',
                                            style: TextStyle(
                                                color: colorScaffold,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      enviarAlGrupo();
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      decoration: BoxDecoration(
                                          color: morado,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        child: Center(
                                          child: Text(
                                            'Unirse al grupo de WhatsApp',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: colorScaffold,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ))
                        ],
                      )),
                ),
              ],
            ),
          )
          //Padding(padding: EdgeInsets.only(top: 10), child: _containerMapa()),
          //btnsDev(),
        ],
      ));
    }

    //Hacer que _recompensa se ejecute todo el tiempo
    //Timer.periodic(Duration(seconds: 2), (timer) {
    //_recompensa();
    //});

    //Crear funcion para actualizar el puntaje

    //Crear funcion para detectar cuando el nivel inicial es diferente al nivel actual

    print(nivel.toString() + ' ' + niveluser.toString());

    return Scaffold(
      backgroundColor: colorScaffold,
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
      body: _bodyIndex(),
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
                    ? "Bienvenido $nickname !"
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
              selectedIndex: 0,
              gap: 6,
              padding: EdgeInsets.all(10),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Inicio', //Exportar la variable tiempo_inicio
                ),
                GButton(
                  icon: Icons.reviews,
                  text: 'Mis Reseñas',
                  onPressed: () {
                    //Exportar la variable tiempo_inicio
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResenasPage(inicio)));
                  },
                ),
                GButton(
                    icon: Icons.coffee_maker_outlined,
                    text: 'Cafeterias',
                    onPressed: () {
                      //Exportar la variable tiempo_inicio
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Cafeterias(inicio)));
                    }),
                GButton(
                  icon: Icons.event_note,
                  text: 'Eventos',
                  onPressed: () {
                    //Exportar la variable tiempo_inicio
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventosPage(inicio)));
                  },
                ),
                GButton(
                  icon: Icons.account_circle,
                  text: 'Configuracion',
                  //Enlace a vista editar perfil desde Index
                  onPressed: () {
                    //Exportar la variable tiempo_inicio
                    Navigator.pushReplacement(
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
