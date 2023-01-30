// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_build_context_synchronously

import 'package:coffeemondo/firebase/autenticacion.dart';
import 'package:coffeemondo/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffeemondo/pantallas/iconos.dart';

class Registro extends StatefulWidget {
  @override
  RegistroApp createState() => RegistroApp();
}

class RegistroApp extends State<Registro> {
  bool isLogin = true;
  @override
  bool _obscureText = true;
  bool obs = true;
  bool obs_icon = true;
  String error_register = '';
  bool _visible_errormsj = false;

  // Obtener los strings ingresados por el usuario para verificar su cuenta en firebase
  final TextEditingController _controladoremail = TextEditingController();
  final TextEditingController _controladorcontrasena = TextEditingController();
  final TextEditingController _controladorcontrasena2 = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        // Se utilizan los strings ingresados por el usuario para almacenar su email y contrasena en firebase auth
        email: _controladoremail.text,
        password: _controladorcontrasena.text,
      );
      print('Cuenta de usuario creada en FIREBASE satisfactoriamente.');
      // pushReplacement remplazará la pantalla actual en la pila de navegacion por la nueva pantalla,
      //lo que significa que el usuario no podra volver a la pantalla anterior al presionar el botón
      //"Atrás" en su dispositivo.
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Tu contrasena es muy debil.');
      } else if (e.code == 'email-already-in-use') {
        error_register = 'El correo electronico ya esta en uso.';
        setState(() {
          _visible_errormsj = true;
        });
        print(error_register);
      }
    } catch (e) {
      print(e);
    }
  }

  // ignore: non_constant_identifier_names
  Widget _Correo(
    TextEditingController controller,
  ) {
    return TextField(
        onTap: () => _visible_errormsj = false,
        controller: controller,
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 14, 148),
          fontSize: 14.0,
          height: 2.0,
          fontWeight: FontWeight.w900,
        ),
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
            ),
            enabledBorder: const UnderlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
            ),
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.account_circle_outlined,
                color: Color.fromARGB(255, 255, 79, 52)),
            suffixIcon:
                Icon(Icons.check, color: Color.fromARGB(255, 84, 14, 148)),
            hintText: 'C o r r e o   e l e c t r o n i c o ',
            hintStyle: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 84, 14, 148),
            )));
  }

  Widget _Contrasena(
    TextEditingController controller,
  ) {
    return TextField(
        onTap: () => _visible_errormsj = false,
        controller: controller,
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 14, 148),
          fontSize: 14.0,
          height: 2.0,
          fontWeight: FontWeight.w900,
        ),
        obscureText: obs,
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
          ),
          enabledBorder: const UnderlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
          ),
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.lock,
              color: Color.fromARGB(255, 255, 79, 52), size: 20),
          suffixIcon: IconButton(
            icon: obs_icon == true
                ? const Icon(Icons.remove_red_eye,
                    color: Color.fromARGB(255, 255, 79, 52), size: 20)
                : const Icon(Icons.remove_red_eye_outlined,
                    color: Color.fromARGB(255, 255, 79, 52), size: 20),
            onPressed: () {
              setState(() {
                obs == true ? obs = false : obs = true;
                obs_icon == true ? obs_icon = false : obs_icon = true;
              });
            },
          ),
          hintText: 'P a s s w o r d',
          hintStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 84, 14, 148)),
        ));
  }

  Widget _mensajeError() {
    if (_visible_errormsj == true) {
      return Text(
        error_register,
        style: TextStyle(
          color: Color.fromARGB(255, 255, 79, 52),
          fontSize: 14.0,
          height: 2.0,
        ),
      );
    } else {
      return const Text('');
    }
  }

  //Crear widget container para mostrar mensaje de error
  Widget _error() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Error al crear la cuenta',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 79, 52),
            fontSize: 14.0,
            height: 2.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Icon(Icons.error_outline,
                  color: Color.fromARGB(255, 255, 79, 52), size: 40),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0), child: _mensajeError()),
          ],
        ))
      ],
    ));
  }

  Widget _Contrasena2(
    TextEditingController controller,
  ) {
    return TextField(
        onTap: () => _visible_errormsj = false,
        controller: controller,
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 14, 148),
          fontSize: 14.0,
          height: 2.0,
          fontWeight: FontWeight.w900,
        ),
        obscureText: obs,
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
          ),
          enabledBorder: const UnderlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
          ),
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.lock_outline,
              color: Color.fromARGB(255, 255, 79, 52), size: 20),
          suffixIcon: IconButton(
            icon: obs_icon == true
                ? const Icon(Icons.remove_red_eye,
                    color: Color.fromARGB(255, 255, 79, 52), size: 20)
                : const Icon(Icons.remove_red_eye_outlined,
                    color: Color.fromARGB(255, 255, 79, 52), size: 20),
            onPressed: () {
              setState(() {
                obs == true ? obs = false : obs = true;
                obs_icon == true ? obs_icon = false : obs_icon = true;
              });
            },
          ),
          hintText: 'C o n f i r m a r   P a s s w o r d',
          hintStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 84, 14, 148)),
        ));
  }

  Widget BotonRegistrarse() {
    final bool isValid = EmailValidator.validate(_controladoremail.text);
    return Container(
      child: Container(
        width: 250,
        height: 50,
        child: CustomPaint(
          painter: BackgroundButton1(),
          child: InkWell(
            onTap: () {
              if (_controladoremail.text == '') {
                setState(() {
                  error_register = 'Debes ingresar un correo electronico.';
                  _visible_errormsj = true;
                });
              } else if (_controladorcontrasena.text == '') {
                setState(() {
                  error_register = 'Debes ingresar una contraseña.';
                  _visible_errormsj = true;
                });
              } else if (_controladorcontrasena2.text == '') {
                setState(() {
                  error_register = 'Debes confirmar la contraseña.';
                  _visible_errormsj = true;
                });
              } else if (!isValid) {
                setState(() {
                  error_register = 'El correo electronico no es valido.';
                  _visible_errormsj = true;
                });
              } else if (_controladorcontrasena.text !=
                  _controladorcontrasena2.text) {
                setState(() {
                  error_register = 'Las contraseñas no coinciden.';
                  _visible_errormsj = true;
                });
              } else {
                createUserWithEmailAndPassword();
              }
            },
            child: Center(
              child: Text(
                'Registrarme',
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

  Widget _error2() {
    return (AnimatedOpacity(
      opacity: _visible_errormsj ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1500),
      child: Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
            left: MediaQuery.of(context).size.width * 0.01,
            right: MediaQuery.of(context).size.width * 0.01),
        width: MediaQuery.of(context).size.width * 0.94,
        height: MediaQuery.of(context).size.height * 0.12,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0x52, 0x01, 0x9b),
          borderRadius: BorderRadius.circular(20),
        ),
        child: //Crear columna que contenga el titulo y el cuerpo del container
            _error(),
      ),
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffebdcac),
      appBar: AppBarcustom(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 50, top: 50, right: 40),
                child: _Correo(_controladoremail)),
            Padding(
                padding: EdgeInsets.only(left: 50, top: 10, right: 40),
                child: _Contrasena(_controladorcontrasena)),
            Padding(
                padding: EdgeInsets.only(left: 50, top: 10, right: 40),
                child: _Contrasena2(_controladorcontrasena2)),
            Padding(padding: EdgeInsets.only(top: 10), child: _error2()),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 40, right: 10),
              child: BotonRegistrarse(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}

//APPBAR CUSTOM

class AppBarcustom extends StatelessWidget implements PreferredSizeWidget {
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
                "Registrarse",
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

//APPBAR CUSTOM

//BOTTOMBAR CUSTOM

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

//BOTTOMBAR CUSTOM

//BOTON CUSTOM

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

//BOTON CUSTOM
