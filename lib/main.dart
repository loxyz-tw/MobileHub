import 'package:flutter/material.dart';
import 'customeWidgets/bottom_navigation_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter bottomNavigationBar',
      theme: new ThemeData.dark(),
      home: BottomNavigationWidget(),
    );
  }
}
