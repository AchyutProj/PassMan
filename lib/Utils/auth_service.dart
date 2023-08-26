import 'package:firebase_auth/firebase_auth.dart';
import 'package:passman/Model/User.dart' as PMAuth;
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

  // Future<String> signIn({required String email, required String password}) async {
  //   try {
  //     await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.setString('lastEmail', email);
  //     _status = AuthStatus.successful;
  //
  //     final firebaseUid = _firebaseAuth.currentUser?.uid ?? '';
  //     prefs.setString('firebaseUid', firebaseUid); // Store Firebase UID in shared preferences
  //
  //     final response = await ApiService.post('login', {'email': email, 'password': password, 'firebase_uid': firebaseUid});
  //
  //     if (response['status'] == 200) {
  //       prefs.setString('_token', json.decode(response['data']));
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     _status = AuthExceptionHandler.handleAuthException(e);
  //   }
  //   return AuthExceptionHandler.generateErrorMessage(_status);
  // }

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('lastEmail', email);

      final firebaseUid = userCredential.user?.uid ?? '';
      prefs.setString('firebaseUid', firebaseUid);

      final response = await ApiService.post('login',
          {'email': email, 'password': password, 'firebase_uid': firebaseUid});

      if (response['status'] == 200) {
        final Map<String, dynamic> responseData = response['data'];
        final String token = responseData['token'];
        final Map<String, dynamic> userData = responseData['user'];

        prefs.setString('_token', token);

        final PMAuth.User user = PMAuth.User.fromJson(userData);
        prefs.setString('user_data', user.toString());

        _status = AuthStatus.successful;
      } else {
        _status = AuthStatus.unknown;
      }
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    } catch (e) {
      _status = AuthStatus.unknown;
    }
    return AuthExceptionHandler.generateErrorMessage(_status);
  }

  Future<String> signUp({
    required String firstName,
    required String middleName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final String firebaseUid = userCredential.user?.uid ?? '';
      final prefs = await SharedPreferences.getInstance();

      prefs.setString('firebaseUid', firebaseUid);

      final Map<String, dynamic> userData = {
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'firebase_uid': firebaseUid,
      };

      final response = await ApiService.post('register', userData);

      if (response['status'] == 200) {
        _status = AuthStatus.successful;
      } else {
        _status = AuthStatus.unknown;
      }
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    } catch (e) {
      _status = AuthStatus.unknown;
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

  Future<void> changePassword(
      {required String password, required String confirmPassword}) async {
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
      if (email != null) {
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
      case AuthStatus.unknown:
        errorMessage = "An unknown error occured.";
        break;
      default:
        errorMessage = "An error occured. Please try again later.";
    }
    return errorMessage;
  }
}
