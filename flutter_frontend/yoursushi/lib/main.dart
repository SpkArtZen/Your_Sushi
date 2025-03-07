import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:yoursushi/model/UserData.dart';
import 'package:yoursushi/pages/forgot_password.dart';
import 'package:yoursushi/pages/login_page.dart';
import 'package:yoursushi/pages/menu_page.dart';
import 'package:yoursushi/pages/registration_page.dart';
import 'package:yoursushi/pages/user_profile.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await dotenv.load(fileName: ".env"); // Завантаження змінних середовища
  Hive.openBox('user');
  fetchUserData();

  runApp(const MyApp());
}
void fetchUserData() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await saveUserData(user.uid);
    }
  } catch (e) {
    print('Помилка при отриманні користувача: $e');
  }
  }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your sushi',
      debugShowCheckedModeBanner: false,
      home: AuthChecker(),
      routes: {
        '/sign_in': (context) => LoginPage(),
        '/sign_up': (context) => RegistrationPage(),
        '/forgot': (context) => ForgotPasswordPage(),
        '/profile': (context) => UserProfile(),
        '/menu': (context) => MenuPage(),
      },
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return MenuPage();
        }
        // Інакше – на сторінку входу
        return LoginPage();
      },
    );
  }
}