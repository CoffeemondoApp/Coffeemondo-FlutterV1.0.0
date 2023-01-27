// ignore_for_file: file_names
import 'package:coffeemondo/pantallas/bienvenida.dart';

import 'package:flutter/material.dart';
import 'package:coffeemondo/pantallas/user_logeado/index.dart';
import 'package:coffeemondo/pantallas/user_logeado/Perfil.dart';
import 'package:coffeemondo/pantallas/user_logeado/Foto.dart';

import './firebase/autenticacion.dart';

class WidgetTree extends StatefulWidget {
  // Archivo WidgetTree creado con la finalidad de corroborar si existe informacion de usuario previamente en la aplicacion
  // Esto permite ofrecer al usuario una mejor experiencia al momento de usar la aplicacion ya que por ejemplo, si con anterioridad
  // El usuario habia ingresado sus datos para iniciar sesion o registrarse, esta se almacena localmente al dispositivo
  // Por lo cual este archivo permite redirigir automaticamente al usuario a la pagina de inicio sin necesidad de que nuevamente ingrese sus datos
  // Si no posee informacion local, la aplicacion solicita el ingreso de datos

  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    //Crear funcion para obtener la hora, minuto y segundo actual
    String _obtenerHoraInicial() {
      return DateTime.now().toString();
    }

    return StreamBuilder(
      // Se llama la clase Auth de auth.dart
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Si existe informacion de usuario redirige a HomePage
          // PerfilPage == editar perfil -o- Index == pagina index por defecto usuario
          return IndexPage((_obtenerHoraInicial()));
        } else {
          // Si no existe informacion de usuario redirige a LoginPage para iniciar o registrar un usuario
          return const MyApp();
        }
      },
    );
  }
}
