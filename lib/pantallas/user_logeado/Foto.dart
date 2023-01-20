// ignore_for_file: use_build_context_synchronously, avoid_print, unused_field, prefer_final_fields, override_on_non_overriding_member, non_constant_identifier_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, annotate_overrides, use_full_hex_values_for_flutter_colors, use_key_in_widget_constructors

import 'package:coffeemondo/pantallas/Registro.dart';
import 'package:coffeemondo/firebase/autenticacion.dart';
import 'package:coffeemondo/pantallas/user_logeado/Info.dart';
import 'package:coffeemondo/pantallas/user_logeado/index.dart';

import 'package:coffeemondo/pantallas/user_logeado/Perfil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class FotoPerfil extends StatefulWidget {
  const FotoPerfil({super.key});

  @override
  FotoApp createState() => FotoApp();
}

class FotoApp extends State<FotoPerfil> {
  String? errorMessage = '';
  bool isLogin = true;
  String tab = '';

  final TextEditingController _controladoremail = TextEditingController();
  final TextEditingController _controladoredad = TextEditingController();
  final TextEditingController _controladornombreUsuario =
      TextEditingController();

  @override
  Widget _NombreApellido(
    TextEditingController controller,
  ) {
    return TextField(
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
          width: 220,
        ),
      ),
      style: ElevatedButton.styleFrom(shape: CircleBorder()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffebdcac),
      appBar: AppBarcustom(),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 80, top: 80, right: 0),
          child: FotoPerfil(),
        )
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
                "Perfil de usuario",
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
    return Stack(
      children: <Widget>[
        Container(
          height: 75,
          color: Colors.transparent,
          child: ClipPath(
              clipper: BackgroundBottomBar(),
              child: Container(
                color: Colors.black,
              )),
        ),
        Container(
          height: 70,
          child: GNav(
              backgroundColor: Color.fromARGB(255, 255, 79, 52),
              color: Color.fromARGB(255, 84, 14, 148),
              activeColor: Color.fromARGB(255, 84, 14, 148),
              tabBackgroundColor: Color.fromARGB(50, 0, 0, 0),
              selectedIndex: 1,
              gap: 8,
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Perfil',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PerfilPage()),
                    );
                  },
                ),
                GButton(
                  icon: Icons.image,
                  text: 'Foto de perfil',
                ),
                GButton(
                  icon: Icons.info,
                  text: 'Informacion',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InfoPage()),
                    );
                  },
                ),
                GButton(
                  icon: Icons.arrow_back,
                  text: 'Volver atras',
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
