import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget{
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<MenuPage>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
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
  Widget build(BuildContext context) {
     final List<Map<String, String>> menuItems = [
      {
        'name': 'Ролл Дракон',
        'ingredients': 'Лосось, Темпура з креветок, Авокадо, Огірок, Ікра тобіко',
        'weight': '260 г',
        'price': '160 грн',
      },
      {
        'name': 'Ролл з тунцем та гострим майонезом',
        'ingredients': 'Норі, Гострий майонез, Огірок',
        'weight': '230 г',
        'price': '145 грн',
      },
      {
        'name': 'Суші з тунецем та авокадо',
        'ingredients': 'Норі, Креветки, Огірок, Ікра тобіко',
        'weight': '160 г',
        'price': '110 грн',
      },
    ];

    return Scaffold(
      drawerEnableOpenDragGesture: true,
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 255, 208, 194),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 208, 194),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end, // Вирівнювання по правому боку
          children: [
            Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontFamily: 'JapaneseFont',
                ),
                children: [
                  TextSpan(
                    text: "Your ",
                    style: TextStyle(color: Colors.white), // Колір для "Your"
                  ),
                  TextSpan(
                    text: "Sushi",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 150, 118)), // Колір для "Sushi"
                  ),
                ],
              ),
            ),
          ],
        ),
        leading: 
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white,),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
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
                  Navigator.pushReplacementNamed(context, '/menu');
                },
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/profile');
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
      body: Stack(
        children: [
          Container(color: Color.fromARGB(255, 255, 208, 194),),
        
      ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return Card(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 150, 118)
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                  Text('Інгредієнти: ${item['ingredients']}'),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text('Вага: ${item['weight']}'),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                    Text('Ціна: ${item['price']}'),
                    ],),
                    FloatingActionButton(onPressed:() => {},
                    child: Icon(Icons.add, color: Colors.white,), 
                    backgroundColor: Color.fromARGB(255, 255, 150, 118),
                    elevation: 5,
                    mini: true,
                    ) ],
              ),
            ])),
          );
        },
      )],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked);
    }

}