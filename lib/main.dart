import 'package:fish_piece/screen/more_screen.dart';
import 'package:fish_piece/widget/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  String currentLocation = '위치 불러오는 중...';
  String weatherInfo = '날씨 불러오는 중...';
  String weatherDescription = '';
  double temperature = 0.0;

  @override
  void initState() {
    super.initState();
    _getLocationAndWeather();
  }

  Future<void> _getLocationAndWeather() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            currentLocation = '위치 권한 거부됨';
            weatherInfo = '-';
          });
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          currentLocation = '위치 설정에서 권한 허용 필요';
          weatherInfo = '-';
        });
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        );
        
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            currentLocation = '${place.administrativeArea} ${place.locality}';
          });
        }
        
        // 날씨 정보 가져오기
        _fetchWeather(position.latitude, position.longitude);
      }
    } catch (e) {
      print('위치 조회 오류: $e');
      setState(() {
        currentLocation = '위치 조회 실패';
        weatherInfo = '-';
      });
    }
  }

  Future<void> _fetchWeather(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code&timezone=Asia/Seoul',
        ),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final current = json['current'];
        
        String description = _getWeatherDescription(current['weather_code']);
        setState(() {
          temperature = (current['temperature_2m'] as num).toDouble();
          weatherDescription = description;
          weatherInfo = '$description ${temperature.toStringAsFixed(1)}°C';
        });
      }
    } catch (e) {
      print('날씨 조회 오류: $e');
    }
  }

  String _getWeatherDescription(int code) {
    if (code == 0) return '맑음';
    if (code == 1 || code == 2) return '흐림';
    if (code == 3) return '흐림';
    if (code == 45 || code == 48) return '안개';
    if (code >= 51 && code <= 67) return '이슬비';
    if (code >= 71 && code <= 77) return '눈';
    if (code >= 80 && code <= 82) return '소나기';
    if (code >= 85 && code <= 86) return '눈소나기';
    if (code >= 95 && code <= 99) return '천둥번개';
    return '날씨 정보';
  }

  Widget _getWeatherIcon() {
    final desc = weatherDescription;
    if (desc.contains('맑음')) {
      return Icon(Icons.wb_sunny, color: Colors.amber, size: 20);
    } else if (desc.contains('흐림')) {
      return Icon(Icons.wb_cloudy, color: Colors.grey, size: 20);
    } else if (desc.contains('이슬비') || desc.contains('소나기')) {
      return Icon(Icons.grain, color: Colors.blue, size: 20);
    } else if (desc.contains('눈')) {
      return Icon(Icons.cloud, color: Colors.blue, size: 20);
    } else if (desc.contains('안개')) {
      return Icon(Icons.cloud, color: Colors.grey, size: 20);
    } else if (desc.contains('천둥')) {
      return Icon(Icons.flash_on, color: Colors.orange, size: 20);
    }
    return Icon(Icons.wb_sunny, color: Colors.amber, size: 20);
  }

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
                Icon(Icons.my_location_sharp, size: 28, color: Color(0xFF0B3D91)),
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      currentLocation,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0B3D91),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      weatherDescription.isNotEmpty ? weatherDescription : '-',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0B3D91),
                      ),
                    ),
                    SizedBox(width: 6),
                    _getWeatherIcon(),
                    SizedBox(width: 6),
                    Text(
                      temperature != 0.0 ? '${temperature.toStringAsFixed(1)}°C' : '-',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0B3D91),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            backgroundColor: Colors.white,
            elevation: 2,
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