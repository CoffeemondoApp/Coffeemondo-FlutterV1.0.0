import 'package:flutter/material.dart';
import 'package:coffeemondo/iconos.dart';

class Registro extends StatefulWidget {
  @override
  RegistroApp createState() => RegistroApp();
}

class RegistroApp extends State<Registro> {
  @override
  bool _obscureText = true;
  bool obs = true;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffebdcac),
      appBar: AppBarcustom(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 50, top: 50, right: 40),
                child: const TextField(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 84, 14, 148),
                      fontSize: 10.0,
                      //fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 79, 52)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_circle_outlined,
                            color: Color.fromARGB(255, 255, 79, 52)),
                        suffixIcon: Icon(Icons.check,
                            color: Color.fromARGB(255, 84, 14, 148)),
                        hintText: 'C o r r e o   e l e c t r o n i c o ',
                        hintStyle: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 84, 14, 148),
                        )))),
            Padding(
                padding: EdgeInsets.only(left: 50, top: 10, right: 40),
                child: TextField(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 84, 14, 148),
                      fontSize: 10.0,
                      //fontWeight: FontWeight.bold,
                    ),
                    obscureText: obs,
                    decoration: InputDecoration(
                      focusedBorder: const UnderlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 255, 79, 52)),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        // width: 0.0 produces a thin "hairline" border
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock,
                          color: Color.fromARGB(255, 255, 79, 52)),
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
                    ))),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 200, right: 10),
              child: CustomButton1(),
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
      child: ClipPath(
        clipper: BackgroundAppBar(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 207, 111, 55),
              Color.fromARGB(255, 207, 111, 55)
            ]),
          ),
          child: Center(
            child: Text(
              'Registro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ),
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
        child: Container(
          color: Color.fromARGB(255, 207, 111, 55),
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

class CustomButton1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

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