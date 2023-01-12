import 'package:coffeemondo/prueba.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'login app',
        home: Scaffold(
          backgroundColor: Color(0xffffebdcac),
          appBar: AppBarcustom(),
          body: Center(
            child: CustomButton(),
          ),
          bottomNavigationBar: CustomBottomBar(),
        ));
  }
}

class CustomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffebdcac),
      body: Center(
        child: Container(
          width: 300,
          height: 50,
          child: CustomPaint(
            painter: BackgroundButton(),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Login()));
              },
              child: Center(
                child: Text(
                  'Presiona aquí',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundButton extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Color color1 = Color.fromRGBO(81, 0, 155, 1.0);
    Color color2 = Color.fromARGB(255, 43, 0, 83);

    final LinearGradient gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color1, color2]);

    final paint = Paint()
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    var path = Path();
    path.lineTo(size.width - 290, size.height - 10);
    path.lineTo(size.width - 10, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class AppBarcustom extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 88.0,
      child: ClipPath(
        clipper: BackgroundAppBar(),
        child: Image.asset(
          'assets/2134.jpg',
          width: MediaQuery.of(context).size.width,
          height: 100,
          fit: BoxFit.cover,
          color: Color.fromARGB(255, 255, 145, 0),
          colorBlendMode: BlendMode.overlay,
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
