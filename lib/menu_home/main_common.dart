// ============================================
// Project: 북클립
// File: lib/menu_home/main_common.dart
// Role: 메인 -> 공통 위젯
// Author: 김건우
// ============================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bookclip/common/const/icon.dart';
import 'package:bookclip/common/const/public_style.dart';

/// 바로가기 - 버튼
class ShortCutButton extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  final String text;

  const ShortCutButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.buttonColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: Offset(0, 1),
              blurRadius: 6.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이콘
            Image.asset(
              icon,
              width: 24.0,
              height: 24.0,
            ),
            const SizedBox(width: 8.0),
            // 텍스트
            Text(
              text,
              style: AppTextStyles.textSize20.copyWith(fontWeight: FontWeight.w600, color: AppColors.backgroundColor,),
            )
          ],
        )
      ),
    );
  }
}

/// 공통 다이얼로그
class AppDialogFrame extends StatelessWidget {
  const AppDialogFrame({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.showCloseButton = false,
    required this.child,
  });

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool showCloseButton;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showCloseButton) ...[
          // 닫기 버튼
          buttonClose(context),
          const SizedBox(height: 20),
        ],
        // 팝업 본체
        Container(
          width: width,
          height: height,
          padding: padding,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                offset: const Offset(0, 1),
                blurRadius: 6,
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  /// 닫기 버튼 위젯
  Widget buttonClose(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: Offset(0, 1),
              blurRadius: 6.0,
              spreadRadius: 0.0,
            ),
          ]
        ),
        child: Image.asset(
          AppButtons.buttonCloseBig,
          width: 60.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// 공통 다이얼로그 호출
Future<T?> showAppDialog<T>(
  BuildContext context, {
  required Widget child,
  bool barrierDismissible = false,
  Duration transitionDuration = const Duration(milliseconds: 250),
  Color? barrierColor,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'AppDialog',
    barrierColor: barrierColor ?? AppColors.fontColor.withValues(alpha: .5),
    transitionDuration: transitionDuration,
    pageBuilder: (context, animation, _) => Center(
      child: PopScope(
        canPop: false,
        child: Material(
          type: MaterialType.transparency,
          child: child,
        ),
      ),
    ),
    transitionBuilder: (context, anim, _, child) {
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1.0).animate(
            CurvedAnimation(parent: anim, curve: Curves.easeOut),
          ),
          child: child,
        ),
      );
    },
  );
}