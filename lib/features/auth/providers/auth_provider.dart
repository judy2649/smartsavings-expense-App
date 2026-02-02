import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/services/service_locator.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = getIt<AuthRepository>();
  
  LocalUser? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _emailVerificationSent = false;
  bool get emailVerificationSent => _emailVerificationSent;

  LocalUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get isEmailVerified => _user?.emailVerified ?? false;

  AuthProvider() {
    _initAuthState();
  }

  void _initAuthState() {
    // Check if there's a current local user
    final localUser = _authRepository.currentLocalUser;
    if (localUser != null) {
      _user = localUser;
      notifyListeners();
    }
  }

  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final credential = await _authRepository.signUp(email: email, password: password);
      _user = _authRepository.currentLocalUser;
      
      // Send verification email
      await _authRepository.sendEmailVerification(email);
      _emailVerificationSent = true;
      
      _isLoading = false;
      notifyListeners();
      return credential;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authRepository.login(email: email, password: password);
      _user = _authRepository.currentLocalUser;
      
      // Check if email is verified
      if (!_user!.emailVerified) {
        _errorMessage = 'Please verify your email before logging in. Check your inbox for the verification link.';
        _emailVerificationSent = true;
        _isLoading = false;
        notifyListeners();
        return;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authRepository.logout();
      _user = null;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authRepository.resetPassword(email);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> confirmPasswordReset({
    required String email,
    required String newPassword,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authRepository.confirmPasswordReset(
        email: email,
        newPassword: newPassword,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle({
    required String email,
    required String displayName,
    String? photoURL,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authRepository.signInWithGoogle(
        email: email,
        displayName: displayName,
        photoURL: photoURL,
      );
      _user = _authRepository.currentLocalUser;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> verifyEmail(String email, String token) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await _authRepository.verifyEmailWithToken(email, token);
      if (result && _user?.email == email) {
        _user!.emailVerified = true;
      }
      
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authRepository.resendVerificationEmail(email);
      _emailVerificationSent = true;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markEmailAsVerified(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authRepository.markEmailAsVerified(email);
      if (_user?.email == email) {
        _user!.emailVerified = true;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }
}
