import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:yoursushi/services/auth_service.dart';
import 'package:yoursushi/widgets/rounded_button.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  bool _obscureText = true;
  bool _obscureRepeatText = true;

  final AuthService authService = AuthService(baseUrl: '');
   bool isValidEmail(String email) {
    // Регулярний вираз для перевірки email
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  bool isValidPhone(String phone) {
    return RegExp(r"^\+380\d{9}$").hasMatch(phone);
  }
  bool isValidPassword() {
    return passwordController.text == repeatPasswordController.text;
  }

  void register() async {
    if (isValidEmail(emailController.text) && isValidPhone(phoneController.text) && isValidPassword()) {
      User? user = await authService.signUpWithEmail(emailController.text, passwordController.text);
      _handleUserSignIn(user, context);
    } else {
      print('Перевірка не пройдена');
    }
  }
  Future<void> _handleUserSignIn(User? user, BuildContext context) async {
    if (user == null) {
      print("User is null");
      return;
    }
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();;

      final userData = {
        "id": user.uid,
        "email": user.email,
        "name": user.displayName,
        "phone": user.phoneNumber ?? "",
        "fcm": fcmToken,
        "avatar_id": 1
      };
      
      bool added = await authService.addUser(userData);
      if (added) {
        Navigator.pushReplacementNamed(context, "/chats");
      } else {
        print("Failed to add user to API");
      }
    } catch (e) {
      print("Error during user data handling: $e");
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
                  vertical: MediaQuery.of(context).size.height * 0.04,
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
                  vertical: MediaQuery.of(context).size.height * 0.01,
                ),
                child: TextField(
                  controller: nameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.white),
                    hintText: "Name",
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
                child: TextField(
                  controller: phoneController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone_android, color: Colors.white),
                    hintText: "Phone",
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
                child: TextField(
                  controller: passwordController,
                  obscureText: _obscureText, // Закриття пароля
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    hintText: "Password",
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
                child: TextField(
                  controller: repeatPasswordController,
                  obscureText: _obscureRepeatText, // Закриття пароля
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureRepeatText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureRepeatText = !_obscureRepeatText;
                        });
                      },
                    ),
                    hintText: "Repeat password",
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
              Padding(padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.01,
                ),
                child: ElevatedButton(
              onPressed: () async {
                register();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 157, 128),
                shadowColor: const Color.fromARGB(255, 255, 157, 127),
              ),
              child: Text("Увійти", style: TextStyle(fontSize: 14, color: Colors.white,)),
            ),),
              Padding(padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.05,
                            vertical: MediaQuery.of(context).size.height * 0.01,
                          ),
                          child: 
              RoundedButton(
                  backgroundColor: Colors.white,
                  assetPath: 'assets/src/icons/google_icon.png',
                  onPressed: () async {
                    try {
                      final user = await authService.signInWithGoogle();
                      _handleUserSignIn(user, context);
                    } catch (e) {
                      print("Error during sign-in: $e");
                    }
                  },
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
