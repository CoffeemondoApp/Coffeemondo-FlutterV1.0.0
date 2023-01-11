import 'package:coffeemondo/Registro.dart';
import 'package:flutter/material.dart';
import 'package:coffeemondo/iconos.dart';

class Login extends StatefulWidget {
  @override
  LoginApp createState() => LoginApp();
}

class LoginApp extends State<Login> {
  bool _obscureText = true;
  bool obs = true;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffebdcac),
      appBar: AppBarcustom(),
      body: SingleChildScrollView(
        child: Column(children: [
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
              padding: EdgeInsets.only(left: 50, top: 50, right: 40),
              child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      hintText: 'Correo electronico'))),
          Padding(
              padding: EdgeInsets.only(left: 50, top: 10, right: 40),
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                          obs == true ? obs = true : obs = false;
                        });
                      },
                    ),
                    hintText: 'Contraseña'),
                obscureText: _obscureText,
              )),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 50, right: 10),
            child: CustomButton1(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20, right: 10),
            child: CustomButtongoogle(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 100, right: 10),
            child: CustomButton2(),
          ),
        ]),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
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
              'Iniciar Sesion',
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
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Login()));
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

//BUTTON CUSTOM GOOGLE

class CustomButtongoogle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: 250,
        height: 50,
        child: CustomPaint(
          painter: BackgroundButtongoogle(),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Registro()));
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

//BUTTON CUSTOM GOOGLE

class CustomButton2 extends StatelessWidget {
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
