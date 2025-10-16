// ============================================
// Project: 북클립
// File: lib/menu_home/main_content.dart
// Role: 메인 -> 콘텐츠
// Author: 김건우
// ============================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookclip/common/const/icon.dart';
import 'package:bookclip/common/const/public_style.dart';
import 'package:bookclip/common/widget/common_content.dart';
import 'package:bookclip/menu_home/book_search.dart';
import 'package:bookclip/menu_home/main_common.dart';
import 'package:bookclip/utils/routes.dart';

/// 메인 콘텐츠
class MainContent extends StatefulWidget {
  final double bgHeight;
  final double overlap;

  const MainContent({
    super.key,
    required this.bgHeight,
    required this.overlap,
  });

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  @override
  Widget build(BuildContext context) {
    const double imageWidth = 115.0;                                              // 최근 도서 이미지 고정 크기
    const double aspectRatio = 1 / 1.5;                                           // 최근 도서 이미지 비율 (width / height)
    const double vPadding = 16.0;                                                 // 최근 도서 AppBoxs의 top, bottom 패딩값
    final double leftContentHeight = (imageWidth / aspectRatio) + (vPadding * 2); // 최근 도서, 바로가기 총 높이
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 배경 이미지
        _mainBackgroundImage(),
        // 메인 콘텐츠
        _MainContentInner(
          leftContentHeight: leftContentHeight,
          bgHeight: widget.bgHeight,
          overlap: widget.overlap,
        ),
      ],
    );
  }

  /// 배경 이미지 위젯
  Widget _mainBackgroundImage() {
    return Positioned(
      top: 0, left: 0, right: 0,
      height: widget.bgHeight,
      child: Image.asset(
        'assets/images/background/main_top.jpg',
        fit: BoxFit.contain,
      ),
    );
  }
}

/// 메인 콘텐츠 내용
class _MainContentInner extends StatefulWidget {
  final double leftContentHeight;
  final double bgHeight;
  final double overlap;

  const _MainContentInner({
    super.key,
    required this.leftContentHeight,
    required this.bgHeight,
    required this.overlap,
  });

  @override
  State<_MainContentInner> createState() => _MainContentInnerState();
}

class _MainContentInnerState extends State<_MainContentInner> {
  final _rememberController = TextEditingController();      // 기억할 문장 TextField 컨트롤러
  Timer? _rememberDebounce;                                 // 저장 타이머 (저장 주기)
  SharedPreferences? _prefs;                                // 기기에 기억할 문장 데이터를 영구 저장하기 위한 인스턴스

  static const _kRememberKey = 'remember_sentence';         // ShardPreferences에 저장될 키 이름

  @override
  void initState() {
    super.initState();

    // 1) ShardPreferences 초기화 및 기존 저장값 불러오기
    // 2) TextField 값 변경 감지 리스너 등록
    _initPrefsAndLoad();
    _rememberController.addListener(_onRememberChanged);
  }

  // ShardPreferences 인스턴스 초기화 후,
  // 저장된 기억할 문장을 불러와서 TextField에 반영
  Future<void> _initPrefsAndLoad() async {
    _prefs ??= await SharedPreferences.getInstance();                       // ShardPreferences가 아직 생성되지 않았다면 인스턴스 요청
    _rememberController.text = _prefs!.getString(_kRememberKey) ?? '';      // null이면 빈 문자열 반환
  }

  // TextField 내용이 바뀔 때마다 호출되는 함수
  // -> 즉시 저장하지 않고 350ms 동안 입력이 멈추면 저장
  void _onRememberChanged() {
    // 이전에 예약된 타이머 취소 (입력 중 계속된 덮어쓰기 방지)
    _rememberDebounce?.cancel();

    // 새 타이머 설정 (350ms 후 저장)
    _rememberDebounce = Timer(const Duration(milliseconds: 350), () async {
      final text = _rememberController.text;

      // 현재 입력 내용 저장
      await _prefs?.setString(_kRememberKey, text);
    });
  }

  @override
  void dispose() {
    // 리소스 정리 (필수!)
    _rememberDebounce?.cancel();      // 타이머 해제
    _rememberController.dispose();    // 컨트롤러 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (widget.bgHeight - widget.overlap),
      left: 0, right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: Offset(0, -2),
              blurRadius: 50.0,
              spreadRadius: 0.0
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 오늘 날짜
              todayWidget(),
              const SizedBox(height: 48.0),
              // 기억할 문장 작성하기
              rememberWidget(),
              const SizedBox(height: 32.0),
              // 나의 기록
              myRecordWidget(),
              const SizedBox(height: 32.0),
              // 최근 도서 & 바로가기
              recentAndShortWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 오늘 날짜 위젯
  Widget todayWidget() {
    final DateFormat dateFormat = DateFormat('yyyy.M.d (EEEE)', 'ko_KR');
    return Text(
      dateFormat.format(DateTime.now()),
      style: AppTextStyles.textSize24,
    );
  }

  /// 기억할 문장 위젯
  Widget rememberWidget() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 문장 입력 박스
        AppBoxs(
          content: TextField(
            controller: _rememberController,
            maxLines: 1,
            textAlign: TextAlign.center,
            cursorColor: AppColors.fontColor,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 17.5),
              border: InputBorder.none,
              hintText: '기억할 문장을 작성해보세요',
              hintStyle: AppTextStyles.textSize14.copyWith(color: AppColors.fontColorLight),
            ),
            style: AppTextStyles.textSize14,
          ),
        ),
        // 아이콘
        Positioned(
          top: -16.0, left: 0, right: 0,
          child: Image.asset(
            AppIcons.iconMiniBook,
            width: 24.0,
            height: 24.0,
          ),
        ),
      ],
    );
  }

  /// 나의 기록 위젯
  Widget myRecordWidget() {
    return CommonContent(
      title: '나의 기록',
      content: AppBoxs(
        paddingVertical: 15.5,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 전체 건수
            _MyRecordCount(type: '전체'),
            // 읽는중 건수
            _MyRecordCount(type: '읽는중'),
            // 완료 건수
            _MyRecordCount(type: '완료'),
          ],
        ),
      ),
    );
  }

  /// 최근 도서 & 바로가기 위젯
  Widget recentAndShortWidget(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 최근 도서
        recentBookWidget(),
        const SizedBox(width: 32.0),
        // 바로가기
        shortcutWidget(context),
      ],
    );
  }

  /// 최근 도서 위젯
  Widget recentBookWidget() {
    return CommonContent(
      title: '최근 도서',
      content: AppBoxs(
        paddingVertical: 16.0,
        paddingHorizontal: 16.0,
        content: SizedBox(
          width: 115.0,
          child: AspectRatio(
            aspectRatio: 1 / 1.5,
            child: Image.asset(
              'assets/images/about/test_image.jpg',
              width: 115,
            ),
          ),
        ),
      ),
    );
  }

  /// 바로가기 위젯
  Widget shortcutWidget(BuildContext context) {
    return Flexible(
      child: CommonContent(
        title: '바로가기',
        content: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: widget.leftContentHeight,
            maxHeight: widget.leftContentHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 기록 작성 버튼
              Expanded(
                child: writeRecord(context)
              ),
              const SizedBox(height: 20.0),
              // 도서 검색 버튼
              Expanded(
                child: BookSearch(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 바로가기 - 기록 작성 버튼 위젯
  Widget writeRecord(BuildContext context) {
    return ShortCutButton(
      onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false),
      icon: AppIcons.iconPenL,
      text: '기록 작성',
    );
  }
}

/// 나의 기록 - 분류 카운팅 위젯
class _MyRecordCount extends StatelessWidget {
  final String type;

  const _MyRecordCount({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 분류
        Text(type, style: AppTextStyles.textSize14),
        const SizedBox(height: 15.0),
        // 수량
        Text('0', style: AppTextStyles.textSize14),
      ],
    );
  }
}