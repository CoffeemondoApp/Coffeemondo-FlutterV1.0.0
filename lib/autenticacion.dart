// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Si existe un usuario logeado, este asigna a currentUser la propiedad currentUser del Auth de FIREBASE
  User? get currentUser => _firebaseAuth.currentUser;

  // Metodo que devuelve un flujo de usuarios autenticados, escucha los cambios en el estado de autenticación del usuario en la app.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Recuperar contrasena
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Iniciar sesion con email
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Registrar cuenta con email
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

// Inicio de sesion con Google
signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn(
    scopes: <String>['email']).signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
}

  // Cerrar sesion
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}



