// 프로젝트 명 : 북클립
// 파일명 : page_main.dart
// 파일 경로 : /lib/menu_home/
// 분류 : 메뉴 - 홈 - 메인

import 'package:flutter/material.dart';

class PageMain extends StatelessWidget {
  const PageMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('메인 화면'),
      ),
    );
  }
}