// main.dart

import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juego de Memoria',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: YourGameWidget(),
    );
  }
}
