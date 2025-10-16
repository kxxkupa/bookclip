// ============================================
// Project: 북클립
// File: lib/menu_library/page_library.dart
// Role: 도서관 페이지
// Author: 김건우
// ============================================

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