import 'package:flutter/material.dart';

class Drawer1 extends StatelessWidget {
  const Drawer1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('data')),
      backgroundColor: Colors.amber[50],
      drawer: Drawer(
        child: Container(
          color: Colors.blueAccent,
          child: ListView(
            children: [
              DrawerHeader(
                child: Container(child: Row(children: [CircleAvatar()])),
              ),
              ListTile(leading: Icon(Icons.abc), title: Text('data')),
            ],
          ),
        ),
      ),
    );
  }
}
