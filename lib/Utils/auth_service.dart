import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'dart:convert';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  AuthStatus _status = AuthStatus.unknown;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('lastEmail', email);
      _status = AuthStatus.successful;

      final response = await ApiService.post('login', {'email': email, 'password': password});

      if (response['status']  == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('_token', json.decode(response['data']));
      }

    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return AuthExceptionHandler.generateErrorMessage(_status);
  }

  Future<String> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return AuthExceptionHandler.generateErrorMessage(_status);
  }

  Future<String> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return AuthExceptionHandler.generateErrorMessage(_status);
  }

  Future<void> changePassword({required String password, required String confirmPassword}) async {
    try {
      if (password == confirmPassword) {
        await _firebaseAuth.currentUser!.updatePassword(password);
      }
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
  }

  Future<String?> getUserEmail(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('lastEmail');
      if(email != null) {
        return email;
      } else {
        AuthService().signOut();
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  userNotFound,
  unknown,
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      case "user-not-found":
        status = AuthStatus.invalidEmail;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }
  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "Your email address appears to be invalid.";
        break;
      case AuthStatus.weakPassword:
        errorMessage = "Your password should be at least 6 characters.";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Your email or password is invalid.";
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage =
        "The email address is already in use by another account.";
        break;
      case AuthStatus.userNotFound:
        errorMessage = "User not found.";
        break;
      case AuthStatus.successful:
        errorMessage = "";
        break;
      default:
        errorMessage = "An error occured. Please try again later.";
    }
    return errorMessage;
  }
}