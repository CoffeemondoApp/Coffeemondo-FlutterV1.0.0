//editar resena
// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeemondo/pantallas/resenas/resenas.dart';
import 'package:coffeemondo/pantallas/user_logeado/Perfil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../firebase/autenticacion.dart';

class EditarResena extends StatefulWidget {
  final String idResena;
  final String cafeteria;
  final String comentario;
  final String resena;
  final String urlFoto;
  

  EditarResena({required this.idResena , required this.cafeteria, required this.comentario, required this.resena, required this.urlFoto});
  @override
  _EditarResenaState createState() => _EditarResenaState();

}

class _EditarResenaState extends State<EditarResena> {


  final _formKey = GlobalKey<FormState>();

  String _nickname = '';
  String _urlFotografia = '';
  String _comentario = '';
  String _resena = '';

  



  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  
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
    final path = 'resena_resena_image/${cafeteria}.jpg';
    final file = File(pickedFile?.path?? widget.urlFoto);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlUserImage = await snapshot.ref.getDownloadURL();

    // Se retorna la url de la imagen para llamarla desde la funcion de guardarInformacion
    return urlUserImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Reseña"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.cafeteria,
                decoration: InputDecoration(labelText: "Nombre de la cafeteria / Home Coffee"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Ingrese nombre de la cafeteria";
                  }
                  return null;
                },
                onSaved: (value) => cafeteria = value!,
              ),
              TextFormField(
                initialValue: widget.comentario,
                decoration: InputDecoration(labelText: "Comentario"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Ingrese comentario";
                  }
                  return null;
                },
                onSaved: (value) => _comentario = value!,
              ),
              TextFormField(
                initialValue: widget.resena,
                decoration: InputDecoration(labelText: "Reseña"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Ingrese la calificacion de la cafeteria";
                  }
                  return null;
                },
                onSaved: (value) => _resena = value!,
              ),
              ElevatedButton(onPressed: () {seleccionarImagen();},
      child: ClipRRect(
          child: pickedFile != null
              ? Image.file(
                  File(pickedFile!.path!),
                  width: 270,
                  height: 270,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  widget.urlFoto,
                  width: 270,
                  height: 270,
                  fit: BoxFit.cover,
                )),),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                        final DocumentReference docRef = FirebaseFirestore
                            .instance
                            .collection("resenas")
                            .doc(
                              widget.idResena
                            );
                        // Se establece los valores que recibiran los campos de la base de datos Firestore con la info relacionada a las resenas
                        docRef.update({
                          'cafeteria': cafeteria,
                          'comentario': _comentario,
                          'reseña': _resena,
                          
                          'urlFotografia': // si el usuario no selecciona una imagen, se mantiene la que ya tenia y si selecciona una, se sube a Firebase Storage y se guarda la url de la imagen
                              pickedFile == null
                                  ? widget.urlFoto
                                  : await subirImagen(),      
                        });
                        print('Ingreso de resena exitoso.');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PerfilPage(''),
                          ),
                        );

                    }
                  }
                ,
                child: Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
