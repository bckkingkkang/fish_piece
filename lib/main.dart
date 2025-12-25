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

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAiTidePreviewWidget(),
            SizedBox(height: 20),
            _buildWeeklyCommunityWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildAiTidePreviewWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF0B3D91),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 0, bottom: 12),
            child: Text(
              '내가 즐겨찾는 장소 물때',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B3D91),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(4, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: 16, left: index == 0 ? 0 : 0),
                  child: _buildTideCard(index),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTideCard(int index) {
    final List<String> locations = ['낚시터 1', '낚시터 2', '낚시터 3', '낚시터 4'];
    final List<String> tideInfo = ['만조 예정', '간조 진행중', '만조 진행중', '간조 예정'];
    final List<String> times = ['14:30', '09:15', '16:45', '11:20'];
    final List<String> descriptions = ['최적 시간까지 2시간 40분', '현재 낚시 황금시간 진행중', '곧 간조 시작 예정', '다음 만조까지 3시간'];

    return GestureDetector(
      onTap: () {
        DefaultTabController.of(context)?.animateTo(3);
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF0B3D91),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Color(0xFF0B3D91),
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  locations[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B3D91),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFF0B3D91).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tideInfo[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0B3D91),
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Colors.grey[600],
                  size: 14,
                ),
                SizedBox(width: 6),
                Text(
                  times[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B3D91),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              descriptions[index],
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 1),
                GestureDetector(
                  onTap: () {
                    DefaultTabController.of(context)?.animateTo(3);
                  },
                  child: Row(
                    children: [
                      Text(
                        '자세히 보기',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B3D91),
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF0B3D91),
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
              _buildHomeScreen(),
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