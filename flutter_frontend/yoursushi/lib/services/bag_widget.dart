import 'package:flutter/material.dart';

class BagWidget extends StatefulWidget{
   @override
  _BagWidgetState createState() => _BagWidgetState();
}
class _BagWidgetState extends State<BagWidget>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shopping List')),
      body: Center(
        child: Text(
          'Welcome to the Shopping App',
          style: TextStyle(fontSize: 24),
        ),
      ),
      // Плаваюча кнопка для виклику знизу вікна
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        foregroundColor: Color.fromARGB(255, 255, 150, 118),
        shape: CircleBorder(),
        child: Icon(
          Icons.shopping_bag,
          size: MediaQuery.of(context).size.width * 0.08,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}