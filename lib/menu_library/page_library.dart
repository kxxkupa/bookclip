// 프로젝트 명 : 북클립
// 파일명 : page_library.dart
// 파일 경로 : /lib/menu_library/
// 분류 : 메뉴 - 도서관 - 메인

import 'package:flutter/material.dart';

class PageLibrary extends StatelessWidget {
  const PageLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('도서관 페이지'),
      ),
    );
  }
}