// ignore_for_file: file_names, prefer_final_fields
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  // Se declara la instancia de firebase en _firebaseAuth
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
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>['email']).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        
        
    return await FirebaseAuth.instance.signInWithCredential(credential);
    
  }

  // Cerrar sesion con email y google
  Future<void> signOut() async {
    // email
    await _firebaseAuth.signOut();
    // google
    await _googleSignIn.signOut();
  }

  // Instancia de google para cerrar sesion
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
}
