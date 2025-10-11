// 프로젝트 명 : 북클립
// 파일명 : app_page.dart
// 파일 경로 : /lib/common/screen/
// 분류 : 메뉴 PageView

import 'package:bookclip/common/widget/app_menu.dart';
import 'package:bookclip/menu_home/page_main.dart';
import 'package:bookclip/menu_library/page_library.dart';
import 'package:bookclip/menu_setting/page_setting.dart';
import 'package:flutter/material.dart';

/// 여러 페이지를 좌우로 넘기면서 볼 수 있는 화면
class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int _index = 0;                   // 메뉴 인덱스
  int? _targetIndex;                // animateToPage의 최종 목표
  bool _animating = false;
  final PageController _controller = PageController();

  // 하단 메뉴에 가리지 않도록 살짝 띄워줌
  static const double _contentBottomPadding = 108.0;

  // 보여줄 페이지들
  final _pages = const [
    PageMain(),
    PageLibrary(),
    PageSetting(),
  ];

  // 메뉴 버튼을 눌렀을 때 실행되는 함수
  void _onTap(int i) async {
    if (_index == i) return;

    setState(() {
      _index = i;          // 하단 메뉴는 즉시 i로 이동
      _targetIndex = i;    // 최종 목표 기록
      _animating = true;   // 지금은 코드로 움직이는 중
    });

    await _controller.animateToPage(
      i,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
    );

    // 애니메이션 끝: 상태 정리
    if (mounted) {
      setState(() {
        _animating = false;
        _targetIndex = null;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();                  // 컨트롤러 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom; // 하단 안전 영역

    return Scaffold(
      extendBody: true, // 화면을 하단 메뉴 아래까지 확장
      body: Stack(
        children: [
          // 실제 페이지 내용
          Padding(
            padding: EdgeInsets.only(
              bottom: _contentBottomPadding + bottomSafe, // 메뉴에 안 가리게 여백
            ),
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) {
                if (!_animating || (_targetIndex != null && i == _targetIndex)) {
                  setState(() => _index = i);
                }
              },
              children: _pages,
            ),
          ),

          // 하단 메뉴 (화면 위에 겹쳐서 표시)
          Align(
            alignment: Alignment.bottomCenter,
            child: AppMenu(
              currentIndex: _index,
              onTap: _onTap,
            ),
          ),
        ],
      ),
    );
  }
}