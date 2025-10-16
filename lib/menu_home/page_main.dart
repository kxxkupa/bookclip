// ============================================
// Project: 북클립
// File: lib/menu_home/page_main.dart
// Role: 메인 페이지
// Author: 김건우
// ============================================

import 'package:flutter/material.dart';
import 'package:bookclip/menu_home/main_content.dart';

/// 메인 페이지
class PageMain extends StatelessWidget {
  const PageMain({super.key});

  // 배경 이미지 높이
  static const double _headerHeightRatio = 5.3 / 10.0;

  // overlap을 화면 폭에 비례하도록 계산
  static ({
    double bgHeight,
    double overlap
  }) _calcLayout(double width) {
    final bgHeight = width * _headerHeightRatio;

    // 폭이 커질수록 살짝 더 겹치되, 범위를 제한해 레이아웃 붕괴 방지
    final rawOverlap = width * 0.22;
    final overlap = rawOverlap.clamp(72.0, 140.0);

    return (bgHeight: bgHeight, overlap: overlap.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final layout = _calcLayout(width);

              return MainContent(
                bgHeight: layout.bgHeight,
                overlap: layout.overlap,
              );
            },
          ),
        ),
      ),
    );
  }
}