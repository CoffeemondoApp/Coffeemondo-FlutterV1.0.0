
// ignore_for_file: file_names, avoid_print, prefer_const_constructors, prefer_interpolation_to_compose_strings, sort_child_properties_last
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeemondo/pantallas/user_logeado/Direccion.dart';
import 'package:coffeemondo/pantallas/user_logeado/Perfil.dart';
import 'package:coffeemondo/pantallas/user_logeado/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../firebase/autenticacion.dart';

class crearResenaPage extends StatefulWidget {
  
  const crearResenaPage({super.key});

  @override
  State<crearResenaPage> createState() => crearResenaPageState();
}

class crearResenaPageState extends State<crearResenaPage> {
  
  final String inicio = '';
  final String nombre_apellido = '';
  final String nombre_usuario = '';
  final String edad = '';
  final String telefono = '';
  final String direccion = '';


  //crea textediting controler de las variables de arriba
  final TextEditingController _inicioController = TextEditingController();
  final TextEditingController _nombre_apellidoController =
      TextEditingController();
  final TextEditingController _nombre_usuarioController =
      TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

  // Se declara la instancia de firebase en la variable _firebaseAuth

  String urlImage = 'https://firebasestorage.googleapis.com/v0/b/coffeemondo-365813.appspot.com/o/resena_resena_image%2Fresena.png?alt=media&token=2c103650-98d2-4e42-86ea-948e915a4070';

  @override
  void initState() {
    super.initState();
  }

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

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
        nickname = userData.data()!['nickname'];
      });
    });
  }

  // mostrarMapa() {
  //   Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => DireccioResenanPage(
  //               inicio,
  //               _inicioController.text,
  //               nombre_apellido,
  //               _nombre_apellidoController.text,
  //               nombre_usuario,
  //               _controladordireccion.text)));
  //               _controladordireccion.text = direccion;
  // }

  // Declaracion de email del usuario actual
  final email = FirebaseAuth.instance.currentUser?.email;

  // Declaracion de controladores para el ingreso de informacion de usuario mediante el teclado
  final TextEditingController _controladorcafeteria = TextEditingController();
  final TextEditingController _controladorcomentario = TextEditingController();
  final TextEditingController _controladorresena = TextEditingController();
  final TextEditingController _controladordireccion = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Si existe un usuario logeado, este asigna a currentUser la propiedad currentUser del Auth de FIREBASE
  User? get currentUser => _firebaseAuth.currentUser;

  var maskFormatter = MaskTextInputFormatter(
      mask: '+(##) # ### ### ##)',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  bool estadoInicial = true;

  Future seleccionarImagen() async {
    final resultado = await FilePicker.platform.pickFiles();
    if (resultado == null) return;

    setState(() {
      pickedFile = resultado.files.first;
    });
  }

  // Funcion para subir al Firebase Storage la imagen seleccionada por el usuario
  Future subirImagen() async {
    // Se reemplaza el nombre de la imagen por el correo del usuario, asi es mas facil identificar que imagen es de quien dentro de Storage
    final path = 'resena_resena_image/${_controladorcafeteria.text}.jpg';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlUserImage = await snapshot.ref.getDownloadURL();

    // Se retorna la url de la imagen para llamarla desde la funcion de guardarInformacion
    return urlUserImage;
  }

// Funcion para crear y guardar resena en la BD de Firestore
  Future<void> guardarResena() async {
    DateTime now = DateTime.now();
    try {
      // Se busca la coleccion 'resenas' de la BD de Firestore
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection("resenas").doc();
      // Se establece los valores que recibiran los campos de la base de datos Firestore con la info relacionada a las resenas
      docRef.set({
        'cafeteria': _controladorcafeteria.text,
        'comentario': _controladorcomentario.text,
        'reseña': _controladorresena.text,
        'urlFotografia': await subirImagen(),
        'direccion': _controladordireccion.text,
        'uid_usuario': currentUser?.uid,
        'nickname_usuario': nickname,
        'fechaCreacion': "${now.day}/${now.month}/${now.year} a las ${now.hour}:${now.minute}",
      });
      print('Ingreso de resena exitoso.');
    } catch (e) {
      print("Error al intentar ingresar resena");
    }
  }

  // Widget para ingresar nombre de usuario
  Widget cafeteria(
    TextEditingController controller,
  ) {
    return TextField(
        controller: controller,
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 14, 148),
          fontSize: 12.0,
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
                color: Color.fromARGB(255, 255, 79, 52), size: 20),
            suffixIcon: Icon(Icons.check,
                color: Color.fromARGB(255, 84, 14, 148), size: 20),
            hintText: 'Cafeteria',
            hintStyle: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 84, 14, 148),
            )));
  }

  // Widget para ingresar nickname
  Widget comentario(
    TextEditingController controller,
  ) {
    return TextField(
        controller: controller,
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 14, 148),
          fontSize: 12.0,
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
                color: Color.fromARGB(255, 255, 79, 52), size: 20),
            suffixIcon: Icon(Icons.check,
                color: Color.fromARGB(255, 84, 14, 148), size: 20),
            hintText: 'Comentario',
            hintStyle: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 84, 14, 148),
            )));
  }

  // Widget para ingresar cumpleanos de usuario
  Widget resena(
    TextEditingController controller,
  ) {
    return TextField(
        controller: controller,
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 14, 148),
          fontSize: 12.0,
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
                color: Color.fromARGB(255, 255, 79, 52), size: 20),
            suffixIcon: Icon(Icons.check,
                color: Color.fromARGB(255, 84, 14, 148), size: 20),
            hintText: 'Reseña',
            hintStyle: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 84, 14, 148),
            )));
  }

  @override
  Widget _Direccion(
    TextEditingController controller,
  ) {
    return TextField(
        inputFormatters: [maskFormatter],
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
            hintText: 'D i r e c c i o n',
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 84, 14, 148),
            )));
  }

  // Widget de boton para guardar la informacion
  Widget botonGuardarResena() {
    return Container(
      child: Container(
        width: 250,
        height: 50,
        child: CustomPaint(
          child: InkWell(
            onTap: () {
              guardarResena();
              Navigator.push(context,
          MaterialPageRoute(builder: (context) => const PerfilPage('')));
            },
            child: Center(
              child: Text(
                'Crear reseña',
                style: TextStyle(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget Fotoresena() {
    return ElevatedButton(
      onPressed: () {seleccionarImagen();},
      child: ClipRRect(
          child: pickedFile != null
              ? Image.file(
                  File(pickedFile!.path!),
                  width: 270,
                  height: 270,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/resena.png',
                  width: 270,
                  height: 270,
                  fit: BoxFit.cover,
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Crear resena'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            cafeteria(_controladorcafeteria),
            comentario(_controladorcomentario),
            resena(_controladorresena),
            _Direccion(_controladordireccion),
            Fotoresena(),
            botonGuardarResena(),
          ],
        ),
      ),
    ));
  }
}