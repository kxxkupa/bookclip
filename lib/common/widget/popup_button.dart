// ============================================
// Project: 북클립
// File: lib/common/widget/popup_button.dart
// Role: 공통 -> 팝업 하단 버튼
// Author: 김건우
// ============================================

import 'package:bookclip/common/const/public_style.dart';
import 'package:flutter/material.dart';

class PopupButton extends StatelessWidget {
  final int buttonNumbers;
  final VoidCallback? onTap_01;
  final VoidCallback? onTap_02;
  final String? buttonText_01;
  final String? buttonText_02;

  const PopupButton({
    super.key,
    required this.buttonNumbers,
    this.onTap_01,
    this.onTap_02,
    this.buttonText_01,
    this.buttonText_02,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 59.0,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap_01,
              child: Container(
                color: AppColors.buttonOnColor,
                child: Center(
                  child: Text(
                    '$buttonText_01',
                    style: AppTextStyles.textSize20.copyWith(color: AppColors.backgroundColor),
                  ),
                ),
              ),
            ),
          ),
          if (buttonNumbers > 1)
            Expanded(
              child: GestureDetector(
                onTap: onTap_02,
                child: Container(
                  color: AppColors.buttonOffColor,
                  child: Center(
                    child: Text(
                      '$buttonText_02',
                      style: AppTextStyles.textSize20.copyWith(color: AppColors.backgroundColor),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}