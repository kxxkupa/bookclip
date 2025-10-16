// ============================================
// Project: 북클립
// File: lib/common/const/public_style.dart
// Role: 스타일 모음
// Author: 김건우
// ============================================

import 'package:flutter/material.dart';

class AppColors {
  // 배경 색상 (#FCFBF9)
  static const backgroundColor = Color(0xFFFCFBF9);

  // 폰트 색상 (#46433F)
  static const fontColor = Color(0xFF46433F);
  
  // 폰트 색상 light (#AFABA5)
  static const fontColorLight = Color(0xFFAFABA5);

  // 하단 네비게이션 (#81775C)
  static const bottomNavigationColor = Color(0xFF81775C);

  // 기본 버튼 (#D3B996)
  static const buttonColor = Color(0xFFD3B996);

  // 버튼 on (#46433F)
  static const buttonOnColor = Color(0xFF46433F);

  // 버튼 off (#9B958D)
  static const buttonOffColor = Color(0xFF9B958D);
}

class AppTextStyles {
  // 폰트
  static const TextStyle textBase = TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w500, color: AppColors.fontColor,);
  
  static const double _letterSpacingRatio = -0.07;

  static final TextStyle textSize10 = textBase.copyWith(fontSize: 10.0, letterSpacing: 10.0 * _letterSpacingRatio);
  static final TextStyle textSize12 = textBase.copyWith(fontSize: 12.0, letterSpacing: 12.0 * _letterSpacingRatio);
  static final TextStyle textSize14 = textBase.copyWith(fontSize: 14.0, letterSpacing: 14.0 * _letterSpacingRatio);
  static final TextStyle textSize16 = textBase.copyWith(fontSize: 16.0, letterSpacing: 16.0 * _letterSpacingRatio);
  static final TextStyle textSize18 = textBase.copyWith(fontSize: 18.0, letterSpacing: 18.0 * _letterSpacingRatio);
  static final TextStyle textSize20 = textBase.copyWith(fontSize: 20.0, letterSpacing: 20.0 * _letterSpacingRatio);
  static final TextStyle textSize24 = textBase.copyWith(fontSize: 24.0, letterSpacing: 24.0 * _letterSpacingRatio);
  static final TextStyle textSize26 = textBase.copyWith(fontSize: 26.0, letterSpacing: 26.0 * _letterSpacingRatio);
  static final TextStyle textSize28 = textBase.copyWith(fontSize: 28.0, letterSpacing: 28.0 * _letterSpacingRatio);
  static final TextStyle textSize30 = textBase.copyWith(fontSize: 30.0, letterSpacing: 30.0 * _letterSpacingRatio);
  static final TextStyle textSize32 = textBase.copyWith(fontSize: 32.0, letterSpacing: 32.0 * _letterSpacingRatio);
}

// 공통 박스 (#F3F0ED)
class AppBoxs extends StatelessWidget {
  final double? marginVertical;
  final double? marginHorizontal;
  final double? paddingVertical;
  final double? paddingHorizontal;
  final Widget content;

  const AppBoxs({
    super.key,
    this.marginVertical,
    this.marginHorizontal,
    this.paddingVertical,
    this.paddingHorizontal,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: marginHorizontal ?? 0.0, vertical: marginVertical ?? 0.0),
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 0.0, vertical: paddingVertical ?? 0.0),
      decoration: BoxDecoration(
        color: Color(0xFFF3F0ED),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: Offset(0, 1),
            blurRadius: 6.0,
            spreadRadius: 0.0,
          ),
        ]
      ),
      child: content,
    );
  }
}