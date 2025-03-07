import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:yoursushi/model/UserData.dart';
import 'package:yoursushi/services/auth_service.dart';

class UserProfile extends StatefulWidget{

  @override
  _UserProfileState createState() => _UserProfileState();
}
class _UserProfileState extends State<UserProfile>{
  late UserData user;
  late Box userBox;
  late bool _isLoaded = false;
  TextEditingController phoneController = new TextEditingController();
  String currentAvatar = "assets/src/images/image1.png";
  final AuthService authService = AuthService(baseUrl: '');
  final List<String> imagePaths = [
    "assets/src/images/image1.png",
    "assets/src/images/image2.png",
    "assets/src/images/image3.png",
    "assets/src/images/image4.png",
    "assets/src/images/image5.png",
    "assets/src/images/image6.png",
    "assets/src/images/image7.png",
  ];
  int _currentIndex = 0;

   void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Щоб контролювати висоту
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Item 1'),
                subtitle: Text('Description of item 1'),
              ),
              ListTile(
                title: Text('Item 2'),
                subtitle: Text('Description of item 2'),
              ),
              ListTile(
                title: Text('Item 3'),
                subtitle: Text('Description of item 3'),
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  void initState(){
    super.initState();
    _loadUserData();
  }
  @override
  void dispose(){
    super.dispose();
  }
  Future<void> _loadUserData() async {
    userBox = await Hive.openBox('user'); // Відкриваємо бокс для користувача

    setState(() {
      user = UserData(
        id: userBox.get('id', defaultValue: ''),
        name: userBox.get('name', defaultValue: ''),
        phone: userBox.get('phone', defaultValue: 'Відстуній номер телефону'),
        fcm: userBox.get('fcm', defaultValue: ''),
        email: userBox.get('email', defaultValue: ''),
        avatar_id: userBox.get('avatar_id', defaultValue: null),
      );
      currentAvatar = "assets/src/images/image${user.avatar_id}.png";
      _currentIndex = user.avatar_id - 1;
      _isLoaded = true;
    });
  }
  void _onAvatarChanged(int index) {
    setState(() {
      currentAvatar = imagePaths[index];
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isLoaded ? Center(child: CircularProgressIndicator()) :Center(
        child: Stack( 
        alignment: AlignmentDirectional(MediaQuery.of(context).size.width * 0, MediaQuery.of(context).size.height * 0,),  
        children: [
        Container(color: Color.fromARGB(255, 255, 208, 194),),
        Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(
        color: Color.fromARGB(255, 255, 208, 194),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3, // ширина кола
              height: MediaQuery.of(context).size.height * 0.3, // висота кола
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 150, 118), // фон
                shape: BoxShape.circle, // форма кола
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.04,
                ),
                child: ClipOval(
                  child: Image.asset(
                    currentAvatar, // використовується поточне зображення
                    fit: BoxFit.contain, // зображення по колу
                  ),
                ),
              ),
            ),
            // Кнопка олівця для відкриття меню
          ],
        ),
      ),
      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
      Column(children: [
Container(
  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.008, horizontal: MediaQuery.of(context).size.width * 0.05), // відступи для контейнера
  decoration: BoxDecoration(
    color: Color.fromARGB(255, 255, 150, 118), // колір фону
    borderRadius: BorderRadius.circular(15), // округлені кути
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start, // вирівнювання тексту по лівому краю
    children: [
      Text(
        user.name,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 5), // відступ між текстами
      Text(
        user.email,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
        ElevatedButton(
              child: Text("Змінити аватар"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Виберіть аватар"),
                    content: CarouselSlider.builder(
                      itemCount: imagePaths.length,
                      itemBuilder: (context, index, realIndex) {
                        return GestureDetector(
                          onTap: () {
                            _onAvatarChanged(index); // Оновлюємо поточний аватар
                            Navigator.pop(context); // Закриваємо діалог
                          },
                          child: ClipOval(
                            child: Image.asset(
                              imagePaths[index],
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.width * 0.3,
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        initialPage: _currentIndex,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    ],
  ),
)
,],),],),

      Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.02),
      child: TextField(
        controller: phoneController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone_android, color: Colors.white),
        hintText: user.phone.isEmpty ? "Введіть номер телефону" :"${user.phone}" ,
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
                var box = Hive.isBoxOpen('user') ? Hive.box('user') : await Hive.openBox('user');
                  await box.put('phone', phoneController.text);
                  await box.put('avatar_id', _currentIndex+1);
                  final userData = {
                    'phone': phoneController.text,
                    'avatar_id': _currentIndex + 1,
                  };
                  bool success = await authService.updateUser(user.id, userData);

                  if (success) {
                    print("User data updated successfully");
                  } else {
                    print("Failed to update user data");
                  }              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 157, 128),
                shadowColor: const Color.fromARGB(255, 255, 157, 127),
              ),
              child: Text("Зберегти", style: TextStyle(fontSize: 14, color: Colors.white,)),
            ),), ],
      ) 
      
    ]
    )
    ),
    bottomNavigationBar: BottomAppBar(
          height: MediaQuery.of(context).size.height * 0.08,
          shape: const CircularNotchedRectangle(),
          notchMargin: MediaQuery.of(context).size.width * 0.02,
          color: Color.fromARGB(255, 255, 150, 118),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.restaurant_menu, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/menu");
                },
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05), // Проміжок для FAB
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/profile");
                },
              ),
            ],
          ),
        ),
       floatingActionButton: Stack(
          clipBehavior: Clip.none,
          children: [
            FloatingActionButton(
              onPressed: () {_openBottomSheet(context);},
              backgroundColor: Colors.white,
              foregroundColor: const Color.fromARGB(255, 255, 150, 118),
              shape: const CircleBorder(),
              child: Icon(Icons.shopping_bag, size: MediaQuery.of(context).size.width * 0.08,),
            ),
            Positioned(
              right: 0,
              top: -(MediaQuery.of(context).size.width * 0.01),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 150, 118),
                  shape: BoxShape.circle,
                ),
                constraints:  BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.05,
                  minHeight: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
  }
}