// ============================================
// Project: 북클립
// File: lib/common/widget/app_menu.dart
// Role: 공통 -> 메뉴
// Author: 김건우
// ============================================

import 'package:bookclip/common/const/icon.dart';
import 'package:bookclip/common/const/public_style.dart';
import 'package:flutter/material.dart';

/// 메뉴
class AppMenu extends StatefulWidget {
  final int currentIndex;        // 현재 선택된 탭 번호(0,1,2)
  final ValueChanged<int> onTap; // 탭 눌렀을 때 호출되는 함수

  const AppMenu({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  // ===== 바 모양/크기 설정 =====
  static const double _menuWidthRatio = 1 / 3; // 메뉴 3개라서 각각 화면의 1/3씩
  static const double _indicatorSize = 28.0;   // 빨간 점 이미지 크기
  static const double _navHeight = 90.0;       // 바 높이
  static const double _overlap = 6.0;          // 위로 살짝 튀어나오게 하는 높이

  double? _prevX;         // 바로 직전 위치 (없으면 첫 실행)
  late double _currentX;  // 지금 위치

  // 탭 번호(index)에 맞는 화면 속 가로 위치를 구함
  double _targetX(BuildContext context, int index) {
    final w = MediaQuery.of(context).size.width;
    // 각 칸의 가운데 위치로 이동
    return w * (index * _menuWidthRatio + (_menuWidthRatio / 2));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 처음 그릴 때 현재 위치 정해두기
    _currentX = _targetX(context, widget.currentIndex);
  }

  @override
  void didUpdateWidget(covariant AppMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 선택된 탭이 바뀌면 이전/새 위치 기록
    if (oldWidget.currentIndex != widget.currentIndex) {
      _prevX = _currentX;
      _currentX = _targetX(context, widget.currentIndex);
    }
  }

  // 이 번호의 탭이 선택됐는지 확인
  bool _isSelected(int i) => widget.currentIndex == i;

  @override
  Widget build(BuildContext context) {
    // 이전 위치 → 새 위치로 부드럽게 옮기기 (전 위치가 없으면 그대로)
    final beginX = _prevX ?? _currentX;
    final endX = _currentX;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: beginX, end: endX),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
      builder: (context, animatedX, child) {
        return SizedBox(
          width: double.infinity,
          height: _navHeight + _overlap,
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              // 메뉴 바
              Positioned(
                left: 0, right: 0, bottom: 0, height: _navHeight,
                child: CustomPaint(
                  painter: _WavePainter(
                    color: AppColors.bottomNavigationColor,
                    cutoutCenter: animatedX, // 파인 중심 위치
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _AppMenuItem(
                          label: '홈',
                          icon: AppIcons.iconHome,
                          isSelect: _isSelected(0),
                          onTap: () => widget.onTap(0),
                        ),
                        _AppMenuItem(
                          label: '도서관',
                          icon: AppIcons.iconLibrary,
                          isSelect: _isSelected(1),
                          onTap: () => widget.onTap(1),
                        ),
                        _AppMenuItem(
                          label: '설정',
                          icon: AppIcons.iconSetting,
                          isSelect: _isSelected(2),
                          onTap: () => widget.onTap(2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 활성화된 메뉴
              Positioned(
                left: animatedX - (_indicatorSize / 2),
                top: -_overlap,
                child: SizedBox(
                  width: _indicatorSize,
                  height: _indicatorSize * (20 / 24),
                  child: Image.asset(
                    'assets/images/about/nav_active.png',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 물결 모양 바를 그리는 도구
class _WavePainter extends CustomPainter {
  final Color color;          // 바 색
  final double cutoutCenter;  // 위쪽이 파인 부분의 가로 중심

  const _WavePainter({
    required this.color,
    required this.cutoutCenter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();

    // 바 전체 네모틀
    path
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0);

    // 곡선
    const notchWidth = 120.0; // 파인 부분의 전체 너비
    const notchDepth = 26.0;  // 얼마나 파일지(깊이)
    const shoulder = 0.0;     // 양끝 직선 길이
    const k = 0.587;          // 곡선 모양을 자연스럽게 만드는 값

    final c = cutoutCenter;   // 가운데 위치
    final dx = notchWidth / 2;
    final dy = notchDepth;

    path
      ..lineTo(c + dx + shoulder, 0)
      ..cubicTo(
        c + dx * (1 - k), 0,
        c + k * dx,       dy,
        c,                dy,
      )
      ..cubicTo(
        c - k * dx,       dy,
        c - dx * (1 - k), 0,
        c - dx - shoulder,0,
      )
      ..lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) {
    return old.color != color || old.cutoutCenter != cutoutCenter;
  }
}

/// 메뉴 요소
class _AppMenuItem extends StatelessWidget {
  final String label;       // 글자
  final String icon;        // 아이콘 경로
  final bool isSelect;      // 선택됨 여부
  final VoidCallback onTap; // 눌렀을 때

  const _AppMenuItem({
    required this.label,
    required this.icon,
    required this.isSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.textSize16.copyWith(
                color: AppColors.backgroundColor,
                fontWeight: isSelect ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}