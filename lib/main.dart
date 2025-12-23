import 'package:fish_piece/screen/more_screen.dart';
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
          appBar: AppBar(
            title: Row(
              children: [
                Icon(Icons.my_location_sharp, size: 28, color: Colors.white),
                SizedBox(width: 10),
                // 아이콘 옆 '현재 위치'의 날씨는 '맑음 25도' 이런 식으로 표시
              ],
            ),
            backgroundColor: Color(0xFF0B3D91),
            elevation: 5,
            centerTitle: false,
          ),
          body : TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children : <Widget> [
              Container(),
              Container(),
              Container(),
              MoreScreen(),
              Container(),
            ] ,
          ),
           bottomNavigationBar: Bottom(),
        ),
      ),
    );
  }
}