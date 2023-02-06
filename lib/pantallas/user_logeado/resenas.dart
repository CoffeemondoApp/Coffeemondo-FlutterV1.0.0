import 'dart:async';
import 'dart:io';
import 'package:coffeemondo/pantallas/resenas/resenas.dart';
import 'package:coffeemondo/pantallas/user_logeado/Direccion.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeemondo/pantallas/user_logeado/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import '../../firebase/autenticacion.dart';
import 'Perfil.dart';
import 'dart:math' as math;

class HalfFilledIcon extends StatelessWidget {
  final IconData? icon;
  final int size;
  double fill;

  HalfFilledIcon(this.fill, this.icon, this.size);
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect rect) {
        return LinearGradient(
          stops: [0, fill, fill],
          colors: [
            Color.fromARGB(255, 0x52, 0x01, 0x9b),
            Color.fromARGB(255, 0x52, 0x01, 0x9b),
            Color.fromARGB(255, 0x52, 0x01, 0x9b).withOpacity(0)
          ],
        ).createShader(rect);
      },
      child: SizedBox(
        width: size.toDouble(),
        height: size.toDouble(),
        child: Icon(icon,
            size: size.toDouble(), color: Color.fromARGB(255, 255, 79, 52)),
      ),
    );
  }
}

class ResenasPage extends StatefulWidget {
  final String tiempo_inicio;
  const ResenasPage(this.tiempo_inicio, {super.key});

  @override
  ResenasPageState createState() => ResenasPageState();
}

double _width_mr1 = 0.0;
double _height_mr1 = 0.0;
double _width_mr2 = 0.9;
double _height_mr2 = 0.3;

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
var nivel = 0;
var niveluser;
var inicio = '';
var promedio ;
bool misResenas = false;
bool misResenas2 = false;
bool crearResena = false;
int _tazas = 0;
int pregunta = 0;
var _cafeteriaSeleccionada = 'Cafetería 1';
var _productoSeleccionado = 'Producto 1';
List<int> calificaciones = [];
bool calificado = false;
bool comentario_presionado = false;
String direccion = '';
bool imagenSeleccionada = false;
String imageFilePath = '';
bool nombre_cafeteria = false;

TextEditingController _nombreCafeteriaController = TextEditingController();
TextEditingController _comentarioController = TextEditingController();
TextEditingController _direccionController = TextEditingController();
TextEditingController _fotoController = TextEditingController();

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
];

//Crear lista con nombre de cafeterias

//Crear funcion que retorne en una lista el nivel del usuario y el porcentaje de progreso
List<Map<String, dynamic>> getNivel() {
  for (var i = 0; i < niveles.length; i++) {
    if (puntaje_actual < niveles[i]['puntaje_nivel']) {
      nivel = niveles[i]['nivel'];
      porcentaje = (puntaje_actual) / niveles[i]['puntaje_nivel'];
      //Cuando sube de nivel se reinicia el porcentaje
      if (nivel > 1) {
        porcentaje =
            (puntaje_actual.toDouble() - niveles[i - 1]['puntaje_nivel']) /
                (niveles[i]['puntaje_nivel'] - niveles[i - 1]['puntaje_nivel']);
        print((niveles[i]['puntaje_nivel'] - puntaje_actual.toDouble()));
      }

      puntaje_nivel = niveles[i]['puntaje_nivel'];
      break;
    }
  }
  return [
    {'nivel': nivel, 'porcentaje': porcentaje, 'puntaje_nivel': puntaje_nivel},
  ];
}

class ResenasPageState extends State<ResenasPage> {
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
  
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  // Funcion para subir al Firebase Storage la imagen seleccionada por el usuario
  Future subirImagen() async {
    // Se reemplaza el nombre de la imagen por el correo del usuario, asi es mas facil identificar que imagen es de quien dentro de Storage
    final path = 'resena_resena_image/${"PENDIENTE"}.jpg';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlUserImage = await snapshot.ref.getDownloadURL();

    // Se retorna la url de la imagen para llamarla desde la funcion de guardarInformacion
    return urlUserImage;
  }

  Future seleccionarImagen() async {
    final resultado = await FilePicker.platform.pickFiles();
    if (resultado == null) return;

    setState(() {
      pickedFile = resultado.files.first;
    });
  }


  // Funcion para crear y guardar resena en la BD de Firestore
  Future<void> guardarResena() async {
    DateTime now = DateTime.now();
    try {
      // Se busca la coleccion 'resenas' de la BD de Firestore
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection("resenas").doc();
      // Se establece los valores que recibiran los campos de la base de datos Firestore con la info relacionada a las resenas
      docRef.set({
        'cafeteria': cafeteria,
        'comentario': _comentarioController.text,
        'urlFotografia': await subirImagen(),
        'direccion': _direccionController.text,
        'uid_usuario': currentUser?.uid,
        'nickname_usuario': nickname,
        'fechaCreacion': "${now.day}/${now.month}/${now.year} a las ${now.hour}:${now.minute}",
      });
      print('Ingreso de resena exitoso.');
    } catch (e) {
      print(cafeteria);
      print(_comentarioController.text);
      print(_direccionController.text);

      print("Error al intentar ingresar resena");
    }
  }

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
        niveluser = userData.data()!['nivel'];
        inicio = widget.tiempo_inicio;
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

  @override
  Widget _textoProgressBar() {
    //Obtener nivel de getNivel()
    int nivel_usuario = getNivel()[0]['nivel'];
    int puntaje_nivel = getNivel()[0]['puntaje_nivel'];
    return (Row(
      children: [
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.3),
          child: Text(
            'Nivel $niveluser',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          '$puntaje_actual_string/$puntaje_nivel',
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
          Container(
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

    Widget _textoPregunta() {
      var texto_pregunta = '';
      switch (pregunta) {
        case 0:
          {
            texto_pregunta = '¿Cómo describirías la atmósfera de la cafetería?';
          }
          break;
        case 1:
          {
            texto_pregunta =
                '¿Cómo describirías la comida y bebidas que ofrecen?';
          }
          break;
        case 2:
          {
            texto_pregunta =
                '¿Qué tan rápido y eficiente es el servicio de meseros?';
          }
          break;
        case 3:
          {
            texto_pregunta =
                '¿El precio de los productos es justo por su calidad?';
          }
          break;
        case 4:
          {
            texto_pregunta =
                '¿Qué tan frecuentemente visitarías la cafetería nuevamente?';
          }
          break;
        case 5:
          {
            texto_pregunta =
                '¿Recomendarías la cafetería a amigos y familiares?';
          }
          break;
        case 6:
          {
            texto_pregunta =
                '¿Qué tan accesible es la ubicación de la cafetería?';
          }
          break;
        case 7:
          {
            texto_pregunta = '¿El personal es amable y servicial?';
          }
          break;
        case 8:
          {
            texto_pregunta =
                '¿La cafetería ofrece opciones para personas con necesidades alimentarias especiales?';
          }
          break;
        case 9:
          {
            texto_pregunta =
                '¿Estás satisfecho con la experiencia en general en la cafetería?';
          }
          break;
      }
      return (Text(texto_pregunta,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: (_tazas != 0)
                  ? Color.fromARGB(255, 255, 79, 52)
                  : Color.fromARGB(255, 255, 255, 255),
              //color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold)));
    }

    @override
    Widget _dropdownCafeteria() {
      bool presionado = false;
      return (
          //Crear dropdown de cafeterias
          DropdownButtonFormField<String>(
        value: _cafeteriaSeleccionada,
        enableFeedback: false,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
        ),
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 0x52, 0x01, 0x9b)))),
        iconSize: 24,
        menuMaxHeight: 150,
        elevation: 4,
        dropdownColor: Color.fromARGB(255, 0x52, 0x01, 0x9b),
        style: TextStyle(color: Color.fromARGB(255, 0x52, 0x01, 0x9b)),
        onTap: () {
          setState(() {
            presionado = true;
          });
        },
        onChanged: (String? newValue) {
          setState(() {
            _cafeteriaSeleccionada = newValue!;
          });
        },
        items: <String>[
          'Cafetería 1',
          'Cafetería 2',
          'Cafetería 3',
          'Cafetería 4',
          'Cafetería 5',
          'Cafetería 6',
          'Cafetería 7',
          'Cafetería 8',
          'Cafetería 9',
          'Cafetería 10',
          'Cafetería 11',
          'Cafetería 12',
          'Cafetería 13',
          'Cafetería 14',
          'Cafetería 15',
          'Cafetería 16',
          'Cafetería 17',
          'Cafetería 18',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 79, 52)),
            ),
          );
        }).toList(),
      ));
    }

    @override
    Widget _dropdownProductos() {
      return ( //Crear dropdown de cafeterias
          DropdownButton<String>(
        alignment: Alignment.center,
        value: _productoSeleccionado,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
        ),
        iconSize: 24,
        elevation: 1,
        style: TextStyle(color: Color.fromARGB(255, 0x52, 0x01, 0x9b)),
        underline: Container(
          height: 0,
          color: Color.fromARGB(0, 29, 19, 39),
        ),
        onChanged: (String? newValue) {
          setState(() {
            _productoSeleccionado = newValue!;
          });
        },
        items: <String>[
          //Crear lista de productos de cafeteria
          'Producto 1',
          'Producto 2',
          'Producto 3',
          'Producto 4',
          'Producto 5',
          'Producto 6',
          'Producto 7',
          'Producto 8',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          );
        }).toList(),
      ));
    }

    @override
    Widget textFieldLista() {
      return (Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 4),
                child: Icon(Icons.coffee_maker_outlined,
                    color: Color.fromARGB(255, 0x52, 0x01, 0x9b)),
              ),
              Container(
                width: 200,
                margin: EdgeInsets.only(left: 10, right: 10, top: 4),
                child: _dropdownCafeteria(),
              ),
              //_dropdownProductos(),
            ],
          ),
          Container(
            height: 2,
            color: Color.fromARGB(255, 84, 14, 148),
          )
        ],
      ));
    }

    @override
    Widget _tazasRanking(double promedio) {
      return (Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (!calificado)
                ? Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                        'La clasificacion es de ' +
                            promedio.toStringAsFixed(1) +
                            ' tazas',
                        style: TextStyle(
                            color: Color.fromARGB(255, 84, 14, 148),
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  )
                : Container(),
            Container(
                margin: EdgeInsets.only(
                    top: (!calificado) ? 10 : 0, left: (!calificado) ? 0 : 109),
                width: (!calificado)
                    ? MediaQuery.of(context).size.width * 0.7
                    : MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    //color: Colors.white,
                    ),
                child: Row(
                  mainAxisAlignment: (!calificado)
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    //Crear iconos de tazas de acuerdo a la calificacion promedio de la tienda
                    HalfFilledIcon(
                      (promedio >= 1) ? 1 : promedio,
                      Icons.coffee,
                      30,
                    ),
                    HalfFilledIcon(
                      (promedio >= 2) ? 1 : promedio - 1,
                      Icons.coffee,
                      30,
                    ),
                    HalfFilledIcon(
                      (promedio >= 3) ? 1 : promedio - 2,
                      Icons.coffee,
                      30,
                    ),
                    HalfFilledIcon(
                      (promedio >= 4) ? 1 : promedio - 3,
                      Icons.coffee,
                      30,
                    ),
                    HalfFilledIcon(
                      (promedio >= 5) ? 1 : promedio - 4,
                      Icons.coffee,
                      30,
                    ),
                  ],
                ))
          ],
        ),
      ));
    }

    @override
    Widget _textFieldComentario(TextEditingController _controller) {
      return (TextFormField(
          maxLength: 119,
          controller: _controller,
          style: const TextStyle(
            color: Color.fromARGB(255, 84, 14, 148),
            fontSize: 14.0,
            height: 2.0,
            fontWeight: FontWeight.w900,
          ),
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 84, 14, 148)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 84, 14, 148)),
              ),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.feedback_outlined,
                  color: Color.fromARGB(255, 84, 14, 148), size: 24),
              hintText: 'Desea agregar algun comentario...',
              hintStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 84, 14, 148),
              ))));
    }

    @override
    Widget _FormComentario(double promedio) {
      return (Padding(
        padding: EdgeInsets.only(top: 0),
        child: Container(
          //decoration:
          //  BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 84, 14, 148), width: 3),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      child: Text(
                        '$promedio',
                        style: TextStyle(
                            color: Color.fromARGB(255, 84, 14, 148),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment(0, 0),
                    ),
                    decoration: BoxDecoration(
                        //color: Colors.red,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        //color: Colors.blue,
                        ),
                    child: Column(children: [
                      Container(
                        child: _tazasRanking(promedio),
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                            //color: Colors.white,
                            ),
                      ),
                      GestureDetector(
                        child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            // Proporciona una curva opcional para hacer que la animación se sienta más suave.
                            curve: Curves.fastOutSlowIn,
                            width: MediaQuery.of(context).size.width * 0.67,
                            height: comentario_presionado ? 70 : 17,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 84, 14, 148),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                            ),
                            margin: EdgeInsets.only(left: 5),
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                (_comentarioController.text != '')
                                    ? _comentarioController.text
                                    : 'Sin comentarios...',
                                textAlign: TextAlign.start,
                                overflow: comentario_presionado
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 79, 52),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        onTap: () {
                          setState(() {
                            comentario_presionado = !comentario_presionado;
                          });
                        },
                      )
                    ]),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 1,
                color: Color.fromARGB(255, 84, 14, 148),
              )
            ],
          ),
        ),
      ));
    }

    navegarDireccion() async {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DireccionPage(
                  widget.tiempo_inicio, '', '', '', '', '', 'cr')));
      setState(() {
        _direccionController.text = result;
      });
      print('este es el resultado: $result');
    }

    @override
    Widget textFieldDireccion(TextEditingController controller) {
      return (TextFormField(
        readOnly: true,
        controller: controller,
        onTap: () {
          //Navegar hacia direccion.dart
          navegarDireccion();
        },
        //controller: _comentarioController,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.location_on,
            color: Color.fromARGB(255, 84, 14, 148),
            size: 34,
          ),
          hintText: 'Ubicacion de la cafeteria/hogar',
          hintStyle: TextStyle(
              color: Color.fromARGB(255, 84, 14, 148),
              fontSize: 16,
              fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 84, 14, 148)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 84, 14, 148)),
          ),
        ),
        style: TextStyle(
            color: Color.fromARGB(255, 84, 14, 148),
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ));
    }

    //List<XFile> imageFile;
    XFile? imageFile;

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

    XFile pickedFile;
    final ImagePicker _picker = ImagePicker();

    Future<void> _showSelectionDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                backgroundColor: Color.fromARGB(255, 84, 14, 148),
                title: Text(
                  "¿Desde donde quieres seleccionar la imagen?",
                  style: TextStyle(color: Color.fromARGB(255, 255, 79, 52)),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          height: 40,
                          child: Center(
                              child: Text(
                            "Galeria",
                            style: TextStyle(
                                color: Color.fromARGB(255, 84, 14, 148),
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 79, 52),
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        onTap: () {
                          seleccionarImagen();
                          Navigator.pop(context);
                        },
                      ),
                      Padding(padding: EdgeInsets.all(8.0)),
                      GestureDetector(
                        child: Container(
                          height: 40,
                          child: Center(
                              child: Text(
                            "Camara",
                            style: TextStyle(
                                color: Color.fromARGB(255, 84, 14, 148),
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 79, 52),
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        onTap: () {
                          _openCamera(context);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ));
          });
    }

    @override
    Widget _inputsFormCR() {
      return (Container(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: textFieldDireccion(_direccionController)),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: GestureDetector(
                    onTap: () {
                      //Seleccionar foto de la galeria
                      if (imagenSeleccionada == false) {
                        _showSelectionDialog(context);
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 5, bottom: 4),
                            //decoration: BoxDecoration(color: Colors.blue),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Color.fromARGB(255, 84, 14, 148),
                                    size: 34,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: (!imagenSeleccionada)
                                        ? Text(
                                            'Foto de la cafeteria/producto',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 84, 14, 148),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            decoration: BoxDecoration(
                                                //color: Colors.white
                                                ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    'Foto seleccionada',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 84, 14, 148),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  //Mostrar foto alojada en imageFilePath
                                                  width: 30,
                                                  height: 30,
                                                  child: Image.file(
                                                    File(imageFilePath),
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              ],
                                            )))
                              ],
                            )),
                        Container(
                            height: 1,
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 84, 14, 148),
                            ))
                      ],
                    ))),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 84, 14, 148),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          guardarResena();
                        },
                        child: Text("Crear Reseña"),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ));
    }

    @override
    Widget _textFieldNombreCafeteria(TextEditingController controller) {
      return (TextFormField(
        controller: controller,
        onChanged: (value) {
          setState(() {
            pregunta = 0;
            _tazas = 0;
            calificaciones = [];
          });
        },
        readOnly: nombre_cafeteria,
        style: TextStyle(
            color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.coffee_maker_outlined,
            color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
            size: 34,
          ),
          hintText: 'Nombre cafetería',
          hintStyle: TextStyle(
              color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
              fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 0x52, 0x01, 0x9b)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 0x52, 0x01, 0x9b)),
          ),
        ),
      ));
    }

    @override
    Widget _mostrarCrearResena() {
      print(_tazas);
      const size_taza = 30.0;
      var promedio = 0.0;
      if (pregunta == 10) {
        print(calificaciones);
        var suma_calificaciones = 0;
        for (int i = 0; i < calificaciones.length; i++) {
          suma_calificaciones += calificaciones[i];
        }
        promedio = suma_calificaciones / calificaciones.length;
        print(promedio);
      }
      print('el largo del comentario es ' +
          _comentarioController.text.length.toString());
      return (AnimatedContainer(
          width: MediaQuery.of(context).size.width * 0.8,
          height: (crearResena)
              ? (pregunta == 10 && !calificado)
                  ? 275
                  : (calificado)
                      ? comentario_presionado
                          ? 365
                          : 310
                      : 200
              : 0,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 79, 52),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          duration: Duration(seconds: 1),
          // Proporciona una curva opcional para hacer que la animación se sienta más suave.
          curve: Curves.fastOutSlowIn,
          child: (crearResena)
              ? Column(

                  children: [
                    //Crear dropdown textfield para seleccionar la cafeteria a la que se le va a hacer la reseña
                    Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            //color: Color.fromARGB(255, 255, 255, 255))
                            ),
                        child: //dropdownCafeteria(),
                            //textFieldLista()
                            Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: _textFieldNombreCafeteria(
                                    _nombreCafeteriaController))),
                    (pregunta != 10)
                        ? Container(
                            margin: EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width * 0.8,
                            //decoration: BoxDecoration(color: Colors.white),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            if (_nombreCafeteriaController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                (_tazas == 1)
                                                    ? _tazas = 0
                                                    : _tazas = 1;
                                              });
                                            }
                                          },
                                          child: Icon(
                                            (_tazas == 1 ||
                                                    _tazas == 2 ||
                                                    _tazas == 3 ||
                                                    _tazas == 4 ||
                                                    _tazas == 5)
                                                ? Icons.coffee
                                                : Icons.coffee_outlined,
                                            color: Color.fromARGB(
                                                255, 84, 14, 148),
                                            size: size_taza,
                                          )),
                                      GestureDetector(
                                          onTap: () {
                                            if (_nombreCafeteriaController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                (_tazas == 2)
                                                    ? _tazas = 0
                                                    : _tazas = 2;
                                              });
                                            }
                                          },
                                          child: Icon(
                                            (_tazas == 2 ||
                                                    _tazas == 3 ||
                                                    _tazas == 4 ||
                                                    _tazas == 5)
                                                ? Icons.coffee
                                                : Icons.coffee_outlined,
                                            color: Color.fromARGB(
                                                255, 84, 14, 148),
                                            size: size_taza,
                                          )),
                                      GestureDetector(
                                          onTap: () {
                                            if (_nombreCafeteriaController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                (_tazas == 3)
                                                    ? _tazas = 0
                                                    : _tazas = 3;
                                              });
                                            }
                                          },
                                          child: Icon(
                                            (_tazas == 3 ||
                                                    _tazas == 4 ||
                                                    _tazas == 5)
                                                ? Icons.coffee
                                                : Icons.coffee_outlined,
                                            color: Color.fromARGB(
                                                255, 84, 14, 148),
                                            size: size_taza,
                                          )),
                                      GestureDetector(
                                          onTap: () {
                                            if (_nombreCafeteriaController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                (_tazas == 4)
                                                    ? _tazas = 0
                                                    : _tazas = 4;
                                              });
                                            }
                                          },
                                          child: Icon(
                                            (_tazas == 4 || _tazas == 5)
                                                ? Icons.coffee
                                                : Icons.coffee_outlined,
                                            color: Color.fromARGB(
                                                255, 84, 14, 148),
                                            size: size_taza,
                                          )),
                                      GestureDetector(
                                          onTap: () {
                                            if (_nombreCafeteriaController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                (_tazas == 5)
                                                    ? _tazas = 0
                                                    : _tazas = 5;
                                              });
                                            }
                                          },
                                          child: Icon(
                                            (_tazas == 5)
                                                ? Icons.coffee
                                                : Icons.coffee_outlined,
                                            color: Color.fromARGB(
                                                255, 84, 14, 148),
                                            size: size_taza,
                                          )),
                                    ],
                                  ),
                                  Text(' $_tazas/5',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 84, 14, 148),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ))
                        : (!calificado)
                            ? Container(
                                child: Column(
                                children: [
                                  _tazasRanking(promedio),
                                  _textFieldComentario(_comentarioController),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        calificado = true;
                                      });
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        height: 40,
                                        margin: EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 84, 14, 148),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Generar clasificacion y comentario',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                  )
                                ],
                              ))
                            : _FormComentario(promedio),
                    (calificado) ? _inputsFormCR() : Container(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_tazas != 0) {
                            pregunta += 1;
                            calificaciones.add(_tazas);
                            nombre_cafeteria = true;
                          }
                          _tazas = 0;
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: (pregunta != 10) ? 60 : 0,
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: (_tazas != 0)
                                ? Color.fromARGB(255, 84, 14, 148)
                                : Color.fromARGB(0, 255, 79, 52),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: _textoPregunta(),
                          )),
                    )
                  ],
                )
              : Container()));
    }

    @override
    Widget _mostrarMenuOpciones() {
      print(crearResena);
      return (AnimatedContainer(
          width: MediaQuery.of(context).size.width * _width_mr2,
          height: (misResenas)
              ? (crearResena)
                  ? (calificado)
                      ? MediaQuery.of(context).size.height / 1.15
                      : MediaQuery.of(context).size.height / 1.4
                  : MediaQuery.of(context).size.height * _height_mr2
              : MediaQuery.of(context).size.height * _height_mr1,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          duration: Duration(seconds: 1),
          // Proporciona una curva opcional para hacer que la animación se sienta más suave.
          curve: Curves.fastOutSlowIn,
          child:
              (misResenas2) //Crear columna que contenga el titulo y el cuerpo del container
                  ? Column(
                      children: [
                        AnimatedOpacity(
                          opacity: misResenas2 ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 3000),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                crearResena = !crearResena;
                                pregunta = 0;
                                _tazas = 0;
                                calificado = false;
                                nombre_cafeteria = false;
                                _direccionController.text = '';
                                _nombreCafeteriaController.text = '';
                                imagenSeleccionada = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.015),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 79, 52),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Crear reseña',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _mostrarCrearResena(),
                        AnimatedOpacity(
                            opacity: misResenas2 ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 3000),
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01),
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 79, 52),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Reseñas anteriores',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))),
                        AnimatedOpacity(
                            opacity: misResenas2 ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 3000),
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01),
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 79, 52),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Reseñas guardadas',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))),
                      ],
                    )
                  : Container()));
    }

    abrirMisResenas() {
      setState(() {
        misResenas = !misResenas;
      });
      if (!misResenas2) {
        Timer(
          const Duration(milliseconds: 900),
          () {
            setState(() {
              misResenas2 = !misResenas2;
            });
            print("mis reseñas = $misResenas");
          },
        );
      } else {
        setState(() {
          misResenas2 = !misResenas2;
        });
      }
    }

    Widget _bodyIndex() {
      return (Center(
        child: Column(
          children: [
            Center(
                child: Container(
                    //Hacer que el container despliegue un menu de opciones al presionarlo
                    child: GestureDetector(
                        onTap: () {
                          abrirMisResenas();
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.2),
                                child: Icon(Icons.reviews,
                                    color: Colors.white, size: 45),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'Mis reseñas',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                        )))),
            _mostrarMenuOpciones()
          ],
        ),
      ));
    }
    //Hacer que _recompensa se ejecute todo el tiempo
    //Timer.periodic(Duration(seconds: 2), (timer) {
    //_recompensa();
    //});

    //Crear funcion para actualizar el puntaje

    //Crear funcion para detectar cuando el nivel inicial es diferente al nivel actual
    _subirNivel() {
      if (nivel != niveluser) {
        setState(() {
          final DocumentReference docRef = FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser?.uid);
          // Se actualiza la informacion del usuario actual mediante los controladores, que son los campos de informacion que el usuario debe rellenar
          docRef.update({
            'nivel': nivel,
          });
          print('Nivel nuevo asignado en Firestore.');
          niveluser = nivel;
          _visible = !_visible;
          //Cambiar estado de _visible luego de 3 segundos
          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              _visible = !_visible;
            });
          });
        });
      }
    }

    _subirNivel();
    print(nivel.toString() + ' ' + niveluser.toString());

    return Scaffold(
      backgroundColor: Color(0xffffebdcac),
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
      body: SingleChildScrollView(child: _bodyIndex()),
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
              gap: 8,
              selectedIndex: 1,
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: ' inicio',
                  onPressed: () {
                    //Exportar la variable tiempo_inicio
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IndexPage(inicio)));
                  },
                ),
                GButton(
                  icon: Icons.reviews,
                  text: 'Reseñas',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Busqueda',
                ),
                GButton(
                  icon: Icons.settings,
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
