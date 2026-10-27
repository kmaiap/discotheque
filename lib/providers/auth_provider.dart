import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// Gerenciador de estado de autenticação de usuários
class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._authService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _authService.currentUser;
  bool get isAuthenticated => currentUser != null;

  // Realiza login com e-mail e senha
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.signIn(email, password);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_formatAuthError(e.code));
      return false;
    } catch (e) {
      _setError('Erro inesperado ao realizar login.');
      return false;
    }
  }

  // Realiza cadastro de novo usuário
  Future<bool> signUp(String email, String password, String name) async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.signUp(
        email: email,
        password: password,
        displayName: name,
      );
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_formatAuthError(e.code));
      return false;
    } catch (e) {
      _setError('Erro ao cadastrar novo usuário.');
      return false;
    }
  }

  // Encerra a sessão atual
  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  // Traduz códigos de erro do Firebase Auth para mensagens amigáveis em pt-BR
  String _formatAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Nenhum usuário encontrado com este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'email-already-in-use':
        return 'Este e-mail já está registrado por outra conta.';
      case 'invalid-email':
        return 'Formato de e-mail inválido.';
      case 'weak-password':
        return 'A senha deve conter no mínimo 6 caracteres.';
      default:
        return 'Falha na autenticação ($code).';
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}

