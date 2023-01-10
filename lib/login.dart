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
      appBar: AppBarcustom(),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/usuario.png'),
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
                            obs == true ? obs = true : obs = false;
                          })
                        },
                        ),
                      hintText: 'Contraseña'))),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 50, right: 10),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Login()));
                },
                child: Text('Entrar'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 50, right: 10),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Login()));
                },
                child: Text('Soy nuevo'),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class AppBarcustom extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: ClipPath(
        clipper: BackgroundAppBar(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color.fromARGB(255, 207, 111, 55), Color(0xFFF6EFE9)]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
              Text('Ingresar'),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}

class BackgroundAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);

    path.lineTo(size.width, size.height - 15);
    path.lineTo(size.width, 0.0);
    return path;
  }

  @override
  bool shouldReclip(BackgroundAppBar oldClipper) => oldClipper != this;
}
