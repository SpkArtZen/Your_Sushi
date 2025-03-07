import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool isButtonEnabled = true; // Для контролю доступності кнопки
  int remainingTime = 0; // Залишковий час
  Timer? _timer; // Таймер для відліку часу
  bool isValidEmail() {
    // Регулярний вираз для перевірки email
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(emailController.text);
  }

  void sendResetEmail() async {
    if (isValidEmail()) {
      String email = emailController.text;
      try {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          print('Лінк для відновлення паролю надіслано');
        } catch (e) {
          print('Помилка: $e');
        }
      // Якщо сервер успішно надіслав лінк на email:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Посилання для відновлення паролю надіслано на $email')),
      );
    }
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 208, 194),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.02,
                ),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.1,
                    fontFamily: 'JapaneseFont'),
                    children: [
                      TextSpan(
                        text: "Your ",
                        style: TextStyle(color: Colors.white), // Колір для "Your"
                      ),
                      TextSpan(
                        text: "Sushi",
                        style: TextStyle(color: Color.fromARGB(255, 255, 150, 118)), // Колір для "Sushi"
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.02,
                ),
                child: TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 150, 118),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 255, 150, 118),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 255, 150, 118),
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 255, 150, 118),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.01,
                ),
                child: ElevatedButton(
              onPressed: () async {
                // register();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 157, 128),
                shadowColor: const Color.fromARGB(255, 255, 157, 127),
              ),
              child: Text("Надіслати листа", style: TextStyle(fontSize: 14, color: Colors.white,)),
            ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
