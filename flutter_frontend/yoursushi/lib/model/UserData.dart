import 'package:hive/hive.dart';
import 'package:yoursushi/services/auth_service.dart';

class UserData {
  String id;
  String name;
  String email;
  String phone;
  String fcm;
  int avatar_id;
  
  UserData({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.fcm,
    required this.avatar_id,
  });
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 'unknown',
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      fcm: json['fcm'],
      avatar_id: json['avatar_id']);
  }
}
 Future<void> saveUserData(String userId) async {
  final AuthService authService = AuthService(baseUrl: '');
    
    try {
      Map<String, dynamic>? userDataJson = await authService.getUser(userId);
      if (userDataJson == null) {
        print('Помилка: Дані користувача не отримані');
        return;
      }
      else{
        print('Дані отримані: ${userDataJson}');
      }
      // Конвертуємо JSON у об'єкт UserData
      UserData userData = UserData.fromJson(userDataJson);
      // Відкриваємо коробку
      var box = Hive.isBoxOpen('user') ? Hive.box('user') : await Hive.openBox('user');

      // Зберігаємо дані
      await box.put('id', userData.id);
      await box.put('name', userData.name);
      await box.put('phone', userData.phone);
      await box.put('fcm', userData.fcm);
      await box.put('email', userData.email);
      await box.put('avatar_id', userData.avatar_id);

      print('Дані користувача успішно збережені');
    } catch (e) {
      print('Помилка при збереженні даних: $e');
    }
  }