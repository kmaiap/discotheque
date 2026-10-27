import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

// Serviço de autenticação com Firebase Auth e sincronização no Firestore
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream com o estado de autenticação do usuário
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Retorna o usuário atualmente autenticado
  User? get currentUser => _auth.currentUser;

  // Realiza login com email e senha
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // Realiza o cadastro de um novo usuário e salva perfil na coleção users
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    if (cred.user != null) {
      await cred.user!.updateDisplayName(displayName);
      await _syncUserToFirestore(cred.user!.uid, email, displayName);
    }
    return cred;
  }

  // Sincroniza dados do usuário no Cloud Firestore (coleção 'users')
  Future<void> _syncUserToFirestore(String uid, String email, String name) async {
    final userModel = UserModel(
      uid: uid,
      email: email.trim().toLowerCase(),
      displayName: name.trim(),
    );
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .set(userModel.toMap());
  }

  // Realiza o encerramento da sessão (logout)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

