// ignore_for_file: use_build_context_synchronously, avoid_print, unused_field, prefer_final_fields, override_on_non_overriding_member, non_constant_identifier_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, annotate_overrides, use_full_hex_values_for_flutter_colors, use_key_in_widget_constructors, sort_child_properties_last

import 'dart:async';

import 'package:coffeemondo/pantallas/Registro.dart';
import 'package:coffeemondo/firebase/autenticacion.dart';
import 'package:coffeemondo/pantallas/user_logeado/Foto.dart';
import 'package:coffeemondo/pantallas/user_logeado/Info.dart';
import 'package:coffeemondo/pantallas/user_logeado/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:coffeemondo/firebase/autenticacion.dart';
import 'package:coffeemondo/login.dart';

//importar morado y naranja de Eventos.dart
const Color colorMorado = Color.fromARGB(255, 84, 14, 148);
const Color colorNaranja = Color.fromARGB(255, 255, 100, 0);

class PerfilPage extends StatefulWidget {
  final String tiempo_inicio;
  const PerfilPage(this.tiempo_inicio, {super.key});

  @override
  PerfilApp createState() => PerfilApp();
}

String tab = '';

class PerfilApp extends State<PerfilPage> {
  @override
  void initState() {
    super.initState();
    // Se inicia la funcion de getData para traer la informacion de usuario proveniente de Firebase
    _getdata();
  }

  // Declaracion de variables de informaicon de usuario
  String nombre = '';
  String nickname = '';
  String cumpleanos = '';
  String telefono = '';
  String direccion = '';
  String urlImage = '';

  String? errorMessage = '';
  bool isLogin = true;

  //Informacion del perfil
  bool infoPerfilPressed = false;
  bool infoPerfilPressed2 = false;

  // Declaracion de email del usuario actual
  final email = FirebaseAuth.instance.currentUser?.email;
  final TextEditingController _controladoremail = TextEditingController();
  final TextEditingController _controladoredad = TextEditingController();
  final TextEditingController _controladortelefono = TextEditingController();
  final TextEditingController _controladornombreUsuario =
      TextEditingController();
  final TextEditingController _controladordireccion = TextEditingController();

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
        telefono = userData.data()!['telefono'];
        direccion = userData.data()!['direccion'];
        urlImage = userData.data()!['urlImage'];
      });
    });
  }

  // Cerrar sesion del usuario
  Future<void> cerrarSesion() async {
    await Auth().signOut();
    print('Usuario ha cerrado sesion');
  }

  @override
  Widget _NombreApellido(
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
            prefixIcon: Icon(Icons.account_circle_outlined,
                color: Color.fromARGB(255, 255, 79, 52), size: 24),
            hintText: nombre,
            hintStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: colorNaranja,
                letterSpacing: 2)));
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
        prefixIcon:
            Icon(Icons.cake, color: Color.fromARGB(255, 255, 79, 52), size: 24),
        hintText: cumpleanos,
        hintStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: colorNaranja,
            letterSpacing: 2),
      ),
    );
  }

  @override
  Widget _Telefono(
    TextEditingController controller,
  ) {
    return TextField(
        readOnly: true,
        keyboardType: TextInputType.phone,
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
            hintText: telefono,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: colorNaranja,
            )));
  }

  Widget FotoPerfil() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FotoPage(inicio)));
        print('Editar foto de perfil');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: urlImage != ''
            ? Image.network(
                urlImage,
                width: 220,
                height: 220,
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/user_img.png',
                width: 220,
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
        controller: controller,
        readOnly: true,
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
            hintText: nickname,
            hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorNaranja,
                letterSpacing: 2)));
  }

  Widget _Correo(
    TextEditingController controller,
  ) {
    return TextField(
        controller: controller,
        readOnly: true,
        // onChanged: (((value) => validarCorreo())),
        style: const TextStyle(
          color: colorNaranja,
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
            prefixIcon: Icon(Icons.email,
                color: Color.fromARGB(255, 255, 79, 52), size: 24),
            hintText: email,
            hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorNaranja,
                letterSpacing: 2)));
  }

  Widget BotonLogin() {
    return Container(
      child: Container(
        width: 250,
        height: 50,
        child: CustomPaint(
          painter: BackgroundButton1(),
          child: InkWell(
            onTap: () {},
            child: Center(
              child: Text(
                'Entrar',
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

  Widget _Direccion(
    TextEditingController controller,
  ) {
    return TextField(
        controller: controller,
        readOnly: true,
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
            hintText: direccion,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorNaranja,
            )));
  }

  // Widget de boton para cerrar sesion
  Widget botonCerrarSesion() {
    return Container(
      child: Container(
        width: 250,
        height: 50,
        child: CustomPaint(
          painter: BackgroundButton1(),
          child: InkWell(
            onTap: () => [
              _MostrarAlerta(context),
            ],
            child: Center(
              child: Text(
                'Cerrar sesion',
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

  //Widget AlerDialog

  Widget AlertaCerrarSesion() {
    return AlertDialog(
      title: Text(
        'Cerrar sesión',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 79, 52),
        ),
      ),
      content: Text(
        '¿Usted desea cerrar su sesión en este dispositivo?',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 79, 52),
        ),
      ),
      backgroundColor: Color.fromARGB(0xff, 0x52, 0x01, 0x9b),
      actions: <Widget>[
        InkWell(
          child: Container(
            width: 50,
            height: 50,
            child: Center(
              child: Text(
                'Si',
                style: TextStyle(color: Color.fromARGB(255, 255, 79, 52)),
              ),
            ),
          ),
          onTap: () {
            cerrarSesion();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
        ),
        InkWell(
          child: Container(
            width: 50,
            height: 50,
            child: Center(
              child: Text(
                'No',
                style: TextStyle(color: Color.fromARGB(255, 255, 79, 52)),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  //Mostrar AlerDialog
  Future<void> _MostrarAlerta(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertaCerrarSesion(),
    );
  }

  Widget moduloInfoPerfil() {
    //hacer que el return se cree luego de 2 segundos
    return (Column(
      children: [
        (infoPerfilPressed2)
            ? Container(
                alignment: (infoPerfilPressed)
                    ? Alignment.topCenter
                    : Alignment.center,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  'Informacion de perfil',
                  style: TextStyle(
                      color: Color(0xffffebdcac),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ))
            : Container(),
        _Correo(_controladoremail),
        _NombreApellido(_controladoremail),
        _NombreUsuario(_controladornombreUsuario),
        _Edad(_controladoredad),
        _Telefono(_controladortelefono),
        _Direccion(_controladordireccion),
      ],
    ));
  }

  Widget build(BuildContext context) {
    print('esto pasa ' + widget.tiempo_inicio);
    print('fecha actual' + DateTime.now().toString());
    return Scaffold(
      backgroundColor: Color(0xffffebdcac),
      appBar: AppBarcustom(),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 10, right: 40),
          child: FotoPerfil(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  infoPerfilPressed = !infoPerfilPressed;
                  // cambiar estado de infoPerfilPressed2 luego de 2 segundos
                  if (!infoPerfilPressed2) {
                    Timer(Duration(milliseconds: 500), () {
                      setState(() {
                        infoPerfilPressed2 = !infoPerfilPressed2;
                      });
                    });
                  } else {
                    infoPerfilPressed2 = !infoPerfilPressed2;
                  }
                });
              },
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: (infoPerfilPressed) ? 370 : 40,
                  decoration: BoxDecoration(
                    color: colorMorado,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: (infoPerfilPressed2)
                      ? moduloInfoPerfil()
                      : Container(
                          alignment: (infoPerfilPressed2)
                              ? Alignment.topCenter
                              : Alignment.center,
                          child: Text(
                            'Informacion de perfil',
                            style: TextStyle(
                                color: Color(0xffffebdcac),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )))),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: colorMorado,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Informacion de usuario',
                  style: TextStyle(
                      color: colorNaranja,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 50, top: 15, right: 40),
            child: botonCerrarSesion()),
      ])),
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
                "Perfil de usuario",
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
              selectedIndex: 0,
              gap: 8,
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Perfil',
                ),
                GButton(
                  icon: Icons.image,
                  text: 'Foto de perfil',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FotoPage(inicio)),
                    );
                  },
                ),
                GButton(
                  icon: Icons.info_outline,
                  text: 'Editar perfil',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              InfoPage(inicio, '', '', '', '', '')),
                    );
                  },
                ),
                GButton(
                  icon: Icons.arrow_back,
                  text: 'Volver atras',
                  onPressed: () {
                    Navigator.push(
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
