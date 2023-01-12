// ignore_for_file: file_names

import 'package:coffeemondo/bienvenida.dart';
import 'package:coffeemondo/home.dart';
import 'package:coffeemondo/login.dart';
import 'package:flutter/material.dart';

import '../Autenticacion.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Se llama la clase Auth de auth.dart
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Si existe informacion de usuario redirige a HomePage
          return const HomePage();
        } else {
          // Si no existe informacion de usuario redirige a LoginPage para iniciar o registrar un usuario
          return MyApp();
        }
      },
    );
  }
}
