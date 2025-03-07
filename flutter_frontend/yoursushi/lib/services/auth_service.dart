import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String? baseUrl;
  AuthService({required this.baseUrl});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  Future<Map<String,dynamic>?> getUser(String id) async {
    final response = await http.get(Uri.parse('${dotenv.env['URL_API']}/users/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));

    }
    return null;
  }
  
  Future<bool> addUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['URL_API']}/users/add'),
       headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userData),
    ).timeout(Duration(seconds: 30));
      print("API Response Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");
    return response.statusCode == 200;
  }
  
  Future<bool> updateUser(String id, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('${dotenv.env['URL_API']}/users/$id'),
      headers: {
        'Content-Type': 'application/json',
      },      
      body: jsonEncode(userData),
    );
    return response.statusCode == 200;
  }
  
  // Реєстрація з Email і Паролем
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
  }

  // Вхід з Email і Паролем
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Sign In Error: $e");
      return null;
    }
  }

  // Вхід через Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }
}