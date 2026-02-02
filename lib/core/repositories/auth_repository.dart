import 'package:firebase_auth/firebase_auth.dart' as fb;

/// Simple local user model for testing without Firebase
class LocalUser {
  final String uid;
  final String email;
  String? displayName;
  String? photoURL;
  bool emailVerified = false;
  bool isAnonymous = false;
  final DateTime createdAt;
  String? passwordHash;

  LocalUser({
    required this.uid, 
    required this.email,
  }) : createdAt = DateTime.now();
}

/// Mock UserCredential for local auth
class MockUserCredential implements fb.UserCredential {
  final LocalUser _localUser;

  MockUserCredential({required LocalUser localUser}) : _localUser = localUser;

  @override
  fb.User? get user => null;

  // expose the underlying LocalUser for tests and local usage
  LocalUser get localUser => _localUser;

  // previousUserCredential and operationType are not part of the
  // fb.UserCredential interface in the targeted SDK, so don't mark
  // them with @override.
  fb.UserCredential? get previousUserCredential => null;

  @override
  fb.AuthCredential? get credential => null;

  dynamic get operationType => null;

  @override
  fb.AdditionalUserInfo? get additionalUserInfo => null;
}

class AuthRepository {
  final fb.FirebaseAuth _auth;
  
  // In-memory user storage for local auth
  static final Map<String, LocalUser> _localUsers = {};
  static final Map<String, String> _passwords = {}; // email -> password
  static LocalUser? _currentLocalUser;
  static final Map<String, String> _resetTokens = {}; // email -> temp token
  
  // Stream controller for auth state changes
  AuthRepository({required fb.FirebaseAuth auth}) : _auth = auth;

  LocalUser? get currentLocalUser => _currentLocalUser;

  Stream<fb.User?> get authStateChanges {
    // delegate to the underlying FirebaseAuth stream so consumers
    // get real auth state updates when running with Firebase.
    return _auth.authStateChanges();
  }

  // Email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  // Password validation
  String? _validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  Future<fb.UserCredential> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    // Validate email
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    // Check if user already exists
    if (_localUsers.values.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
      throw Exception('User with this email already exists');
    }

    // Validate password
    final passwordError = _validatePassword(password);
    if (passwordError != null) {
      throw Exception(passwordError);
    }

    // Create new local user
    final uid = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final newUser = LocalUser(uid: uid, email: email);
    newUser.displayName = displayName ?? email.split('@')[0];
    
    _localUsers[uid] = newUser;
    _passwords[email.toLowerCase()] = password;
    _currentLocalUser = newUser;

    return MockUserCredential(localUser: newUser);
  }

  Future<fb.UserCredential> login({
    required String email,
    required String password,
  }) async {
    // Validate email
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    // Find user by email
    final user = _localUsers.values.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
      orElse: () => throw Exception('User not found. Please sign up first'),
    );

    // Verify password
    final storedPassword = _passwords[email.toLowerCase()];
    if (storedPassword != password) {
      throw Exception('Incorrect password');
    }

    _currentLocalUser = user;
    return MockUserCredential(localUser: user);
  }

  Future<void> logout() async {
    _currentLocalUser = null;
  }

  Future<void> resetPassword(String email) async {
    // Validate email
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    // Check if user exists (will throw if not found)
    _localUsers.values.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
      orElse: () => throw Exception('No account found with this email'),
    );

    // Create reset token (in real app, would send email)
    final resetToken = 'reset_${DateTime.now().millisecondsSinceEpoch}';
    _resetTokens[email.toLowerCase()] = resetToken;
    
    // In production: Send email with reset link
  }

  Future<void> confirmPasswordReset({
    required String email,
    required String newPassword,
  }) async {
    // Validate email
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    // Check if reset token exists
    if (!_resetTokens.containsKey(email.toLowerCase())) {
      throw Exception('Password reset request expired');
    }

    // Validate new password
    final passwordError = _validatePassword(newPassword);
    if (passwordError != null) {
      throw Exception(passwordError);
    }

    // Update password
    _passwords[email.toLowerCase()] = newPassword;
    _resetTokens.remove(email.toLowerCase());
  }

  // Google Sign-in simulation
  Future<fb.UserCredential> signInWithGoogle({
    required String email,
    required String displayName,
    String? photoURL,
  }) async {
    // Check if user exists, if not create
    LocalUser? user = _localUsers.values.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
      orElse: () => LocalUser(uid: '', email: ''),
    );

    if (user.uid.isEmpty) {
      // Create new user from Google
      final uid = 'google_${DateTime.now().millisecondsSinceEpoch}';
      user = LocalUser(uid: uid, email: email);
      user.displayName = displayName;
      user.photoURL = photoURL;
      user.emailVerified = true;
      
      _localUsers[uid] = user;
      // No password needed for Google auth
      _passwords[email.toLowerCase()] = 'google_auth';
    }

    _currentLocalUser = user;
    return MockUserCredential(localUser: user);
  }
}
