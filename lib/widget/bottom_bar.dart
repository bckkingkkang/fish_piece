import 'package:flutter/material.dart';

// BottomBar의 경우 상태관리가 필요없는 위젯이기 때문에 StatelessWidget 사용
class Bottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF0B3D91),
      child: Container(
        height: 70,
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade400,
          indicatorColor: Colors.transparent,
          tabs : <Widget> [
            // 5개의 각 탭 생성
            Tab(
              icon : Icon(
                Icons.home,
                size : 27,
              ),
              child : Text(
                '메인화면',
                style : TextStyle(
                  fontSize : 12,
                )
              )
            ),
            Tab(
              icon : Icon(
                Icons.military_tech_outlined,
                size : 27,
              ),
              child : Text(
                '동네 랭킹',
                style : TextStyle(
                  fontSize : 12,
                )
              )
            ),
            Tab(
              icon : Icon(
                Icons.people_alt_outlined,
                size : 27,
              ),
              child : Text(
                '커뮤니티',
                style : TextStyle(
                  fontSize : 12,
                )
              )
            ),
            Tab(
              icon : Icon(
                Icons.not_listed_location_outlined,
                size : 27,
              ),
              child : Text(
                '더 보기',
                style : TextStyle(
                  fontSize : 12,
                )
              )
            ),
            Tab(
              icon : Icon(
                Icons.sailing_outlined,
                size : 27,
              ),
              child : Text(
                '내 정보',
                style : TextStyle(
                  fontSize : 12,
                )
              )
            ),
          ]
        ),
      ),
    );
  }
}