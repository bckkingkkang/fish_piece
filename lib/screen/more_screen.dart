import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF5F5F5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // AI 기반 물 때 보기 메뉴
            GestureDetector(
              onTap: () {
                // TODO: AI 기반 물 때 보기 페이지로 이동
              },
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Color(0xFF0B3D91), Color(0xFF1E5BA8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.water_drop, size: 40, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'AI 기반 물 때 보기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '최적의 낚시 시간을 AI가 알려줍니다',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // AI 챗봇 메뉴
            GestureDetector(
              onTap: () {
                // TODO: AI 챗봇 페이지로 이동
              },
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Color(0xFF0B3D91), Color(0xFF1E5BA8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.chat_bubble, size: 40, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'AI 챗봇',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '낚시 관련 질문을 AI에게 물어보세요',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}