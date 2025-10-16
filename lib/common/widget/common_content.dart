// ============================================
// Project: 북클립
// File: lib/common/widget/common_content.dart
// Role: 공통 -> 콘텐츠 틀
// Author: 김건우
// ============================================

import 'package:bookclip/common/const/public_style.dart';
import 'package:flutter/material.dart';

class CommonContent extends StatelessWidget {
  final String title;
  final Widget content;

  const CommonContent({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 콘텐츠 타이틀
        Text(
          title,
          style: AppTextStyles.textSize16.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 16.0),

        // 콘텐츠 박스
        content
      ],
    );
  }
}