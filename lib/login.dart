// ignore_for_file: use_build_context_synchronously, avoid_print, unused_field, prefer_final_fields, override_on_non_overriding_member, non_constant_identifier_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, annotate_overrides, use_full_hex_values_for_flutter_colors, use_key_in_widget_constructors

import 'package:coffeemondo/Registro.dart';
import 'package:coffeemondo/autenticacion.dart';
import 'package:coffeemondo/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginApp createState() => LoginApp();
}

class LoginApp extends State<Login> {

String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controladoremail = TextEditingController();
  final TextEditingController _controladorcontrasena = TextEditingController(); 

  // Validacion con cuenta email de usuario
  Future<void> signInWithEmailAndPassword() async {
    try {
      // Se llama a la funcion iniciar con email declarada en Autentication.dart
      await Auth().signInWithEmailAndPassword(
          email: _controladoremail.text, password: _controladorcontrasena.text);
      print('Inicio de sesion con email satisfactorio.');
      // pushReplacement remplazará la pantalla actual en la pila de navegacion por la nueva pantalla,
      //lo que significa que el usuario no podra volver a la pantalla anterior al presionar el botón
      //"Atrás" en su dispositivo.
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No se ha encontrado un usuario asociado a este email.');
      } else if (e.code == 'wrong-password') {
        print('Contrasena incorrecta.');
      }
    }
  }

// Validaciones con cuenta google de usuario
  Future<void> signInWithGoogle() async {
    try {
      // Se guarda en result el resultado de iniciar sesion con google
    var resultado = await Auth().signInWithGoogle();
    // En el caso de que el usuario intente ingresar con cuenta de google pero este no ingrese ninguna devolvera nulo y vuelve return para
    // no ingresar a un usuario sin haber iniciado sesion al HomePage de la aplicacion
    // Se debe ingresar esta validacion ya que por defecto, si un usuario intenta ingresar con google y este no selecciona ninguna cuenta, la 
    // aplicacion redirigira al usuario al HomePage.
    if (resultado == null) return;
    // En el caso contrario, al usuario que inicio con una cuenta google este es redirigido a HomePage
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomePage()));
    print('Inicio de sesion con google satisfactorio.');
} on FirebaseAuthException catch(e) {
    print(e.message);
    rethrow;
}
  }

  bool _obscureText = true;
  bool obs = true;

  @override
  Widget _Correo(
        TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 14, 148),
          fontSize: 10.0,
          //fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
            ),
            enabledBorder: UnderlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: BorderSide(color: Colors.grey, width: 0.0),
            ),
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.account_circle_outlined,
                color: Color.fromARGB(255, 255, 79, 52)),
            suffixIcon:
                Icon(Icons.check, color: Color.fromARGB(255, 84, 14, 148)),
            hintText: 'C o r r e o   e l e c t r o n i c o ',
            hintStyle: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 84, 14, 148),
            )));
  }

  Widget _Contrasena(
        TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 14, 148),
          fontSize: 10.0,
          //fontWeight: FontWeight.bold,
        ),
        obscureText: obs,
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
          ),
          enabledBorder: const UnderlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          border: const OutlineInputBorder(),
          prefixIcon:
              const Icon(Icons.lock, color: Color.fromARGB(255, 255, 79, 52)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.remove_red_eye,
                color: Color.fromARGB(255, 255, 79, 52)),
            onPressed: () {
              setState(() {
                obs == true ? obs = false : obs = true;
              });
            },
          ),
          hintText: 'P a s s w o r d',
          hintStyle: const TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 84, 14, 148)),
        ));
  }

  Widget BotonLogin() {
    return Container(
      child: Container(
        width: 250,
        height: 50,
        child: CustomPaint(
          painter: BackgroundButton1(),
          child: InkWell(
            onTap: () {
              signInWithEmailAndPassword();
            },
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

  Widget botonGoogle() {
    return Container(
      child: Container(
        width: 250,
        height: 50,
        child: CustomPaint(
          painter: BackgroundButtongoogle(),
          child: InkWell(
            onTap: () {
              signInWithGoogle();
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 15,
                      height: 12,
                      child: Image.asset('assets/google.png')),
                  SizedBox(width: 10), // Spacer
                  Text(
                    'Iniciar Sesion con Google',
                    style: TextStyle(
                      color: Color.fromARGB(255, 97, 2, 185),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffebdcac),
      appBar: AppBarcustom(),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/logo.png'),
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 50, top: 50, right: 40),
              child: _Correo(_controladoremail)),
          Padding(
              padding: EdgeInsets.only(left: 50, top: 10, right: 40),
              child: _Contrasena(_controladorcontrasena)),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 50, right: 10),
            child: BotonLogin(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20, right: 10),
            child: botonGoogle(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 100, right: 10),
            child: Botonregistrar(),
          ),
        ]),
      ),
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
      height: 88.0,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: BackgroundAppBar(),
            child: Image.asset(
              'assets/Granos.png',
              width: MediaQuery.of(context).size.width,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 15,
            child: Center(
              child: Text(
                "Iniciar Sesión",
                style: TextStyle(
                  color: Colors.white,
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
  Size get preferredSize => Size.fromHeight(88.0);
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
    return Container(
      height: 80.0,
      width: double.infinity,
      child: ClipPath(
        clipper: BackgroundBottomBar(),
        child: Image.asset(
          'assets/Granos.png',
          width: MediaQuery.of(context).size.width,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
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
