// ignore_for_file: use_build_context_synchronously, avoid_print, unused_field, prefer_final_fields, override_on_non_overriding_member, non_constant_identifier_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, annotate_overrides, use_full_hex_values_for_flutter_colors, use_key_in_widget_constructors

import 'dart:async';

import 'package:coffeemondo/pantallas/Registro.dart';
import 'package:coffeemondo/firebase/autenticacion.dart';
import 'package:coffeemondo/pantallas/user_logeado/Foto.dart';
import 'package:coffeemondo/pantallas/user_logeado/Direccion.dart';
import 'package:coffeemondo/pantallas/user_logeado/Info.dart';
import 'package:coffeemondo/pantallas/user_logeado/Perfil.dart';
import 'package:coffeemondo/pantallas/user_logeado/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

//Obtener variable desde direccion.dart

class InfoUsuarioPage extends StatefulWidget {
  final String inicio;

  const InfoUsuarioPage(this.inicio, {super.key});

  @override
  InfoUsuarioApp createState() => InfoUsuarioApp();
}

var largo_nombre_usuario = 15;

class InfoUsuarioApp extends State<InfoUsuarioPage> {
  @override
  void initState() {
    super.initState();
    // Se inicia la funcion de getData para traer la informacion de usuario proveniente de Firebase
    _getdata();
  }

  // Se declara la instancia de firebase en la variable _firebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Si existe un usuario logeado, este asigna a currentUser la propiedad currentUser del Auth de FIREBASE
  User? get currentUser => _firebaseAuth.currentUser;

  String? errorMessage = '';
  bool isLogin = true;
  bool mostrarSetCafeteras = false;
  bool mostrarSetCafeteras2 = false;
  String nombreCafetera = '';

  // Este estado define si el usuario aun no ha editado ningun textField,
  //si edita alguno, se dejan de recibir en tiempo real los datos de la bbdd
  //para asi poder modificar los campos sin ser reseteados
  bool estadoInicial = true;
  // Declaracion de email del usuario actual
  final email = FirebaseAuth.instance.currentUser?.email;

  final TextEditingController _controladoremail = TextEditingController();
  final TextEditingController _controladoredad = TextEditingController();
  final TextEditingController _controladortelefono = TextEditingController();
  final TextEditingController _controladordireccion = TextEditingController();
  final TextEditingController _controladornombreUsuario =
      TextEditingController();
  final TextEditingController _controladornombreApellido =
      TextEditingController();

  final ScrollController _scrollController = ScrollController();

  // Funcion para guardar informacion del usuario en Firebase Firestore
  Future<void> guardarInfoUsuario() async {
    try {
      // Importante: Este tipo de declaracion se utiliza para solamente actualizar la informacion solicitada y no manipular informacion adicional, como lo es la imagen y esto permite no borrar otros datos importantes

      // Se busca la coleccion 'users' de la BD de Firestore en donde el uid sea igual al del usuario actual
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection("users").doc(currentUser?.uid);
      // Se actualiza la informacion del usuario actual mediante los controladores, que son los campos de informacion que el usuario debe rellenar
      docRef.update({
        'nombre': _controladornombreApellido.text,
        'nickname': _controladornombreUsuario.text,
        'direccion': _controladordireccion.text,
        'cumpleanos': _controladoredad.text,
        'telefono': _controladortelefono.text,
      });
      print('Ingreso de informacion exitoso.');
      // Una vez actualizada la informacion, se devuelve a InfoUser para mostrar su nueva informacion
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const PerfilPage('0')));
    } catch (e) {
      print("Error al intentar ingresar informacion");
    }
  }

  mostrarMapa() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DireccionPage(
                inicio,
                _controladornombreApellido.text,
                _controladornombreUsuario.text,
                _controladoredad.text,
                _controladortelefono.text,
                _controladordireccion.text,
                'ip')));
  }

  String nombre = '';
  String nickname = '';
  String cumpleanos = '';
  String telefono = '';
  String direccion = '';

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
        direccion = userData.data()!['direccion'];
        cumpleanos = userData.data()!['cumpleanos'];
        telefono = userData.data()!['telefono'];
      });
    });
  }

  @override
  Widget _NombreApellido(
    TextEditingController controller,
  ) {
    return TextField(
        onTap: () {
          setState(() {
            estadoInicial = false;
          });
        },
        controller: controller,
        // onChanged: (((value) => validarCorreo())),
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 14, 148),
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
            prefixIcon: Icon(Icons.account_circle_outlined,
                color: Color.fromARGB(255, 255, 79, 52), size: 24),
            hintText: 'N o m b r e  y  A p e l l i d o',
            hintStyle: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 84, 14, 148),
            )));
  }

  var mes_nacimiento = '';
  void getMes(numero_mes) {
    var meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    for (int i = 0; i < meses.length; i++) {
      if (i == numero_mes - 1) {
        print((numero_mes - 1).toString());
        print(meses[i]);
        mes_nacimiento = meses[i];
      }
    }
  }

  @override
  Widget _Edad(
    TextEditingController controller,
  ) {
    return TextField(
      readOnly: true,
      controller: controller,
      // onChanged: (((value) => validarCorreo())),
      style: const TextStyle(
        color: Color.fromARGB(255, 84, 14, 148),
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
          prefixIcon: Icon(Icons.cake,
              color: Color.fromARGB(255, 255, 79, 52), size: 24),
          hintText: 'E d a d',
          hintStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 84, 14, 148),
          )),
      onTap: () async {
        DateTime? pickeddate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2024),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Color.fromARGB(255, 255, 79, 52), // <-- SEE HERE
                    onPrimary: Color.fromARGB(255, 84, 14, 148), // <-- SEE HERE
                    onSurface: Color.fromARGB(255, 84, 14, 148), //<-- SEE HERE
                    secondary: Color.fromARGB(255, 235, 220, 172),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      primary:
                          Color.fromARGB(255, 255, 79, 52), // button text color
                    ),
                  ),
                ),
                child: child!,
              );
            });

        if (pickeddate != null) {
          getMes(pickeddate.month);
          setState(() {
            var string_fecha = pickeddate.day.toString() +
                ' de ' +
                mes_nacimiento +
                ' de ' +
                pickeddate.year.toString();
            print(string_fecha);
            print("esta es la fecha ingresada");
            estadoInicial = false;
            _controladoredad.text = string_fecha;
          });
        }
      },
    );
  }

  @override
  Widget FotoPerfil() {
    return ElevatedButton(
      onPressed: () {
        print('Editar foto de perfil');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: const Image(
          image: AssetImage('./assets/user_img.png'),
          width: 150,
        ),
      ),
      style: ElevatedButton.styleFrom(shape: CircleBorder()),
    );
  }

  @override
  Widget _NombreUsuario(
    TextEditingController controller,
  ) {
    return TextField(
        maxLength: largo_nombre_usuario,
        onTap: () {
          setState(() {
            estadoInicial = false;
          });
        },
        //darle un texto inicial al textfield para que se vea el texto de ejemplo y no el hinttext que es el texto que se muestra cuando no hay nada escrito
        controller: controller,
        // onChanged: (((value) => validarCorreo())),
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 14, 148),
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
            prefixIcon: Icon(Icons.account_circle_rounded,
                color: Color.fromARGB(255, 255, 79, 52), size: 24),
            hintText: 'N o m b r e   u s u a r i o',
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 84, 14, 148),
            )));
  }

  //Formato telefono CL
  var maskFormatter = MaskTextInputFormatter(
      mask: '+(##) # ### ### ##)',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget _Telefono(
    TextEditingController controller,
  ) {
    return TextField(
        onTap: () {
          setState(() {
            estadoInicial = false;
          });
        },
        keyboardType: TextInputType.phone,
        inputFormatters: [maskFormatter],
        controller: controller,
        // onChanged: (((value) => validarCorreo())),
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 14, 148),
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
            prefixIcon: Icon(Icons.mobile_friendly_outlined,
                color: Color.fromARGB(255, 255, 79, 52), size: 24),
            hintText: 'T e l e f o n o',
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 84, 14, 148),
            )));
  }

  @override
  Widget _Direccion(
    TextEditingController controller,
  ) {
    return TextField(
        inputFormatters: [maskFormatter],
        controller: controller,
        readOnly: true,
        onTap: (() => {mostrarMapa(), estadoInicial = false}),
        // onChanged: (((value) => validarCorreo())),
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 14, 148),
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
            prefixIcon: Icon(Icons.location_on,
                color: Color.fromARGB(255, 255, 79, 52), size: 24),
            hintText: 'D i r e c c i o n',
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 84, 14, 148),
            )));
  }

  //Funcion para saber cuanto tiempo lleva el usuario en la app

  Widget BotonEditarInfo() {
    return Container(
      child: Container(
        width: 250,
        height: 50,
        child: CustomPaint(
          painter: BackgroundButton1(),
          child: InkWell(
            onTap: () {
              guardarInfoUsuario();
            },
            child: Center(
              child: Text(
                'Editar informacion',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void seleccionarCafetera(Map cafetera) {
    setState(() {
      mostrarSetCafeteras = !mostrarSetCafeteras;
      nombreCafetera = cafetera['nombre'];
      if (!mostrarSetCafeteras2) {
        Timer(Duration(milliseconds: 500), () {
          setState(() {
            mostrarSetCafeteras2 = !mostrarSetCafeteras2;
          });
        });
      } else {
        mostrarSetCafeteras2 = !mostrarSetCafeteras2;
      }
    });
    print(nombreCafetera);
    ;
  }

  //crear array con objetos dentro
  List<Map> _crearCafeteras() {
    final List<Map> cafeteras = [];
    final List<String> cafeteras_nombre = [
      'prensa francesa',
      'moka italiana',
      'V60',
      'kalitta',
      'aeroPress',
      'maquina de espresso'
    ];
    final List<String> cafeteras_descripcion = [
      'La Prensa Francesa es un\nmétodo por inmersión*,\n' +
          'permite controlar todo el\nproceso de extracción,\n' +
          'desde el tiempo de\n contacto, la temperatura\ny la turbulencia,' +
          '\nentre otras variables.\n\nTambién al actuar\ndirectamente sobre' +
          'todo\nel café molido nos da la\nposibilidad' +
          'de extraer\n muy bien los sabores.',
      'La cafetera italiana o\ncafetera moka produce\nun café de calidad,\n' +
          'intenso y con cuerpo\nen pocos minutos.\n\nEs la forma casera de\n' +
          'conseguir un café\nexpreso a baja presión,\nmucho más parecido\n' +
          'al de los bares que\nel café de goteo.',
      'Un único orificio grande\nen el V60 permite\nmodificar el sabor al\n' +
          'alterar la velocidad del\nflujo de agua.\n\nCon este método se\n' +
          'obtiene un café de\ncuerpo sedodo\ny sabor frutal.',
      'Es una cafetera de filtro\nparecida al V60 que\nconsiste en verter ' +
          'agua\ncaliente sobre el café\nmolido contenido en\nun filtro.\n\nEl ' +
          'agua pasa a través\nde la cama de café,\nobtiene sus\ncomponentes ' +
          'y se\nfiltra a un recipiente.',
      'Es como una jeringuilla\ngigante, en el interior\nde la cual se ' +
          'mezclan\ncafé y agua caliente\ny el café se extrae por\nla presión ' +
          'de un émbolo.\n\nEl método aeropress\ncuenta cada vez con\nmás adeptos ' +
          'porque\npermite preparar un\ncafé excelente y con\nmucho ' +
          'cuerpo en\ncuestión de segundos.',
      'Calientan el agua para\nlograr una alta presión\nque pasa por el café\n' +
          'molido para hacer la\ninfusión.\n\nGeneralmente a 90°\ngrados, a ' +
          'presión de\n8-10 atmósferas por\n20 a 30 segundos por\ncafé molido ' +
          'muy fino,\nextrayendo su sabor\ny esencia.'
    ];

    for (var i = 0; i < 6; i++) {
      cafeteras.add({
        'nombre': cafeteras_nombre[i],
        'imagen': 'assets/cafetera${i + 1}.jpg',
        'descripcion': cafeteras_descripcion[i],
      });
    }
    return cafeteras;
  }

  Future<void> guardarCafetera() async {
    try {
      // Importante: Este tipo de declaracion se utiliza para solamente actualizar la informacion solicitada y no manipular informacion adicional, como lo es la imagen y esto permite no borrar otros datos importantes

      // Se busca la coleccion 'users' de la BD de Firestore en donde el uid sea igual al del usuario actual
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection("users").doc(currentUser?.uid);
      // Se actualiza la informacion del usuario actual mediante los controladores, que son los campos de informacion que el usuario debe rellenar
      docRef.update({
        'cafetera': nombreCafetera,
      });
      print('Ingreso de informacion exitoso.');
      // Una vez actualizada la informacion, se devuelve a InfoUser para mostrar su nueva informacion
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const PerfilPage('0')));
    } catch (e) {
      print("Error al intentar ingresar informacion");
    }
  }

  Widget _bodyInfoUsuario() {
    var cafeteras = _crearCafeteras();
    return (Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: MediaQuery.of(context).size.width * 0.95,
              height: mostrarSetCafeteras ? 380 : 30,
              decoration: BoxDecoration(
                  color: colorMorado, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: GestureDetector(
                    child: Container(
                        alignment: mostrarSetCafeteras2
                            ? Alignment.topCenter
                            : Alignment.center,
                        margin:
                            EdgeInsets.only(top: mostrarSetCafeteras2 ? 20 : 0),
                        child: mostrarSetCafeteras2
                            ? Column(children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mostrarSetCafeteras =
                                          !mostrarSetCafeteras;

                                      // cambiar estado de infoPerfilPressed2 luego de 2 segundos
                                      if (!mostrarSetCafeteras2) {
                                        Timer(Duration(milliseconds: 500), () {
                                          setState(() {
                                            mostrarSetCafeteras2 =
                                                !mostrarSetCafeteras2;
                                          });
                                        });
                                      } else {
                                        mostrarSetCafeteras2 =
                                            !mostrarSetCafeteras2;
                                      }
                                    });
                                  },
                                  child: Text(
                                    '¿Que cafetera usas en tu casa?',
                                    style: TextStyle(
                                        color: Color(0xffffebdcac),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                //Crear slide de cards con las cafeteras disponibles
                                Container(
                                    margin: EdgeInsets.only(top: 20),
                                    height: 290,
                                    child: ListView.builder(
                                        controller: _scrollController,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: cafeteras.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return (Container(
                                            margin: EdgeInsets.only(right: 10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.91,
                                            child: Card(
                                              color: colorNaranja,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    FittedBox(
                                                      child: Image.asset(
                                                        cafeteras[index]
                                                            ['imagen'],
                                                        width: 210,
                                                        height: 282,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            cafeteras[index]
                                                                ['nombre'],
                                                            style: TextStyle(
                                                              color:
                                                                  colorMorado,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 20,
                                                                    right: 10),
                                                            //color: Colors.white,
                                                            height: 200,
                                                            child: Text(
                                                              cafeteras[index][
                                                                  'descripcion'],
                                                              style: TextStyle(
                                                                  color:
                                                                      colorMorado,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                              maxLines: null,
                                                            )),
                                                        GestureDetector(
                                                            onTap: () {
                                                              seleccionarCafetera(
                                                                  cafeteras[
                                                                      index]);
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 10,
                                                                      top: 10,
                                                                      bottom:
                                                                          10),
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      colorMorado,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              5,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                  child: Text(
                                                                    'Seleccionar cafetera',
                                                                    style: TextStyle(
                                                                        color:
                                                                            colorNaranja,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )),
                                                            ))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                        }))
                              ])
                            : GestureDetector(
                                child: Text(
                                  (nombreCafetera != '')
                                      ? 'En mi casa uso $nombreCafetera'
                                      : '¿Que cafetera usas en tu casa?',
                                  style: TextStyle(
                                      color: Color(0xffffebdcac),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  setState(() {
                                    mostrarSetCafeteras = !mostrarSetCafeteras;

                                    // cambiar estado de infoPerfilPressed2 luego de 2 segundos
                                    if (!mostrarSetCafeteras2) {
                                      Timer(Duration(milliseconds: 500), () {
                                        setState(() {
                                          mostrarSetCafeteras2 =
                                              !mostrarSetCafeteras2;
                                        });
                                      });
                                    } else {
                                      mostrarSetCafeteras2 =
                                          !mostrarSetCafeteras2;
                                    }
                                  });
                                },
                              ))),
              ),
            ),
            GestureDetector(
              onTap: () {
                guardarCafetera();
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 30,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: colorNaranja,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      'Guardar informacion',
                      style: TextStyle(
                          color: colorMorado, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )),
            )
          ],
        )));
  }

  Widget build(BuildContext context) {
    //          VALORES INICIALES TEXTFIELD EDITAR INFORMACION
    print(estadoInicial);

    return Scaffold(
      backgroundColor: Color(0xffffebdcac),
      appBar: AppBarcustom(),
      body: SingleChildScrollView(child: _bodyInfoUsuario()),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}

//CUSTOM APP BAR
class AppBarcustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarcustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: BackgroundAppBar(),
            child: Container(
              color: Color.fromARGB(0xff, 0x52, 0x01, 0x9b),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
              child: Text(
                "Editar usuario",
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
  Size get preferredSize => Size.fromHeight(100);
}
//CUSTOM APP BAR

//CUSTOM PAINTER APP BAR
class BackgroundAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);

    path.lineTo(size.width, size.height - 20);
    path.lineTo(size.width, 0.0);
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
              selectedIndex: 3,
              gap: 8,
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Perfil',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => PerfilPage(inicio)),
                    );
                  },
                ),
                GButton(
                  icon: Icons.image,
                  text: 'Foto de perfil',
                   onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FotoPage(inicio)),
                    );
                  },                 
                ),
                GButton(
                  icon: Icons.info_outline,
                  text: 'Editar perfil',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InfoPage(inicio, '', '', '', '', '')),
                    );
                  },
                  
                ),
                GButton(
                  icon: Icons.info,
                  text: 'Editar usuario',
                  
                ),
                GButton(
                  icon: Icons.arrow_back,
                  text: 'Volver atras',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IndexPage(inicio)),
                    );
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

//CUSTOM PAINTER BOTON ENTRAR
class BackgroundButton1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Color color1 = Color.fromARGB(255, 97, 2, 185);
    Color color2 = Color.fromARGB(255, 43, 0, 83);

    final LinearGradient gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color1, color2]);

    final paint = Paint()
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    var path = Path();
    path.lineTo(size.width - 240, size.height - 10);
    path.lineTo(size.width - 10, size.height - 3);
    path.lineTo(size.width, size.height - 52);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

//CUSTOM PAINTER BOTON ENTRAR
class Botonregistrar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: 250,
        height: 50,
        child: CustomPaint(
          painter: BackgroundButton2(),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Registro()));
            },
            child: Center(
              child: Text(
                'Soy Nuevo',
                style: TextStyle(
                  color: Color.fromARGB(255, 97, 2, 185),
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundButtongoogle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Color color1 = Color.fromARGB(197, 219, 219, 219);

    final LinearGradient gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color1, color1]);

    final paint = Paint()
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    var path = Path();
    path.lineTo(size.width - 240, size.height - 10);
    path.lineTo(size.width - 10, size.height - 3);
    path.lineTo(size.width, size.height - 52);

    path.close();

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
//CUSTOM PAINTER BOTON GOOGLE

//CUSTOM PAINTER BOTON REGISTRARSE
class BackgroundButton2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Color color1 = Color.fromARGB(255, 97, 2, 185);
    final paint = Paint()
      ..color = color1
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    var path = Path();
    path.lineTo(size.width - 240, size.height - 10);
    path.lineTo(size.width - 10, size.height - 3);
    path.lineTo(size.width, size.height - 52);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
//CUSTOM PAINTER BOTON REGISTRARSE
