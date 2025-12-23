import 'package:fish_piece/widget/bottom_bar.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : 'Fish Piece',
      theme : ThemeData(
      
      ),
      home : DefaultTabController(
        length : 5,
        child : Scaffold(
          body : TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children : <Widget> [
              Container(),
              Container(),
              Container(),
              Container(),
              Container(),
            ] ,
          ),
           bottomNavigationBar: Bottom(),
        ),
      ),
    );
  }
}