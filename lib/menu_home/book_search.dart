// ============================================
// Project: 북클립
// File: lib/menu_home/book_search.dart
// Role: 메인 -> 도서 검색
// Author: 김건우
// ============================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bookclip/common/const/icon.dart';
import 'package:bookclip/common/const/public_style.dart';
import 'package:bookclip/common/env/env.dart';
import 'package:bookclip/common/widget/popup_button.dart';
import 'package:bookclip/data/datasources/remote/kakao_book_api.dart';
import 'package:bookclip/data/models/kakao_book.dart';
import 'package:bookclip/menu_home/main_common.dart';
import 'package:bookclip/utils/routes.dart';

/// 도서 검색 팝업
class BookSearch extends StatelessWidget {
  const BookSearch({super.key});

  void showBookSearchDialog(BuildContext context) {
    showAppDialog(
      context,
      child: AppDialogFrame(
        showCloseButton: true,
        width: 360.0,
        height: 720.0,
        padding: const EdgeInsets.all(32.0),
        child: const BookSearchDialogContentContent(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShortCutButton(
      onTap: () => showBookSearchDialog(context),
      icon: AppIcons.iconSearch,
      text: '도서 검색',
    );
  }
}

/// 도서 검색 팝업 내용
class BookSearchDialogContentContent extends StatelessWidget {
  const BookSearchDialogContentContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BookSearchAPI(),
        ),
      ],
    );
  }
}

/// 도서 검색 API 연결
class BookSearchAPI extends StatefulWidget {
  const BookSearchAPI({super.key});

  @override
  State<BookSearchAPI> createState() => BookSearchAPIState();
}

class BookSearchAPIState extends State<BookSearchAPI>{
  late final KakaoBookApi api;
  final _text = TextEditingController();
  final _scroll = ScrollController();

  List<BookDoc> _items = [];
  String _q = '';
  int _page = 1;
  bool _isLoading = false;
  bool _isEnd = true;
  Object? _error;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    api = KakaoBookApi(apiKey: Env.kakaoKey);
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _text.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 200) {
      _fetchMore();
    }
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _search(value.trim());
    });
  }

  Future<void> _search(String q) async {
    if (q.isEmpty) {
      setState(() {
        _q = '';
        _items = [];
        _page = 1;
        _isEnd = true;
        _error = null;
      });
      return;
    }
    setState(() {
      _q = q;
      _page = 1;
      _isEnd = false;
      _isLoading = true;
      _error = null;
    });
    try {
      final res = await api.searchBooks(query: q, page: 1, size: 20); // KakaoBook 반환
      setState(() {
        _items = res.documents;
        _isEnd = res.isEnd;
      });
    } catch (e) {
      setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchMore() async {
    if (_isLoading || _isEnd || _q.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final res = await api.searchBooks(query: _q, page: _page + 1, size: 20);
      setState(() {
        _page += 1;
        _items.addAll(res.documents);
        _isEnd = res.isEnd;
      });
    } catch (e) {
      setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 팝업 내부 레이아웃: 상단 입력 + 하단 리스트
    return Column(
      children: [
        // 입력 박스 (기존 AppBoxs 스타일 적용)
        AppBoxs(
          content: SizedBox(
            height: 44.0,
            child: TextField(
              controller: _text,
              onChanged: _onChanged,
              maxLines: 1,
              textAlign: TextAlign.center,
              cursorColor: AppColors.fontColor,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 13.5),
                border: InputBorder.none,
                hintText: '도서명을 입력해주세요',
                hintStyle: AppTextStyles.textSize14.copyWith(color: AppColors.fontColorLight),
              ),
              style: AppTextStyles.textSize14,
            ),
          ),
        ),
        const SizedBox(height: 16.0),

        // 결과 리스트
        Expanded(
          child: AppBoxs(
            content: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_error != null) {
      return Center(
        child: Text('오류: $_error', style: AppTextStyles.textSize14)
      );
    }
    if (_q.isEmpty && _items.isEmpty) {
      return Center(
        child: Text('찾으려는 도서명을 검색해주세요', style: AppTextStyles.textSize14.copyWith(color: AppColors.fontColorLight)),
      );
    }
    if (_isLoading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () => _search(_q),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            controller: _scroll,
            itemCount: _items.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, i) {
              // 스냅샷(이 빌드 사이클에서 고정)
              final items = List<BookDoc>.from(_items);
              final showLoader = _isLoading && !_isEnd;

              // 로딩 셀
              if (showLoader && i == items.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // 범위 가드 (혹시 모를 경합 대비)
              if (i < 0 || i >= items.length) {
                return const SizedBox.shrink();
              }

              final searchItem = _items[i];

              return _BookTile(
                book: searchItem,
                isFirst: i,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// 검색 결과 아이템 타일 (썸네일/제목/저자/출판사)
class _BookTile extends StatelessWidget {
  final BookDoc book;
  final int isFirst;

  const _BookTile({
    required this.book,
    required this.isFirst,
  });

  // 도서 정보 팝업
  void showBookInfoDialog(BuildContext context, BookDoc book) {
    showAppDialog(
      context,
      barrierDismissible: false,
      child: AppDialogFrame(
        width: 382,
        height: 510,
        child: _BookInfoDialogContent(
          book: book,
          onRecord: () {
            Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false);
          },
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showBookInfoDialog(context, book),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        margin: isFirst == 0 ? const EdgeInsets.only(bottom: 4.0)
                              : const EdgeInsets.symmetric(vertical: 4.0),
        child: Material(
          color: AppColors.backgroundColor,
          elevation: 6.0,
          shadowColor: Colors.black.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 썸네일
                if (book.thumbnail.isNotEmpty)
                  Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(color: AppColors.fontColor.withValues(alpha: 0.25), width: 1.0,),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      book.thumbnail,
                      width: 48,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  SizedBox(
                    width: 48, height: 72,
                    child: Image.asset(
                      'assets/images/about/default_image.png',
                      width: 60.0,
                    ),
                  ),
                const SizedBox(width: 12),
                // 텍스트
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.textSize14.copyWith(fontWeight: FontWeight.w600)
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${book.authors.join(", ")} • ${book.publisher}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.textSize12.copyWith(color: AppColors.fontColorLight),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 도서 정보 팝업 내용
class _BookInfoDialogContent extends StatelessWidget {
  final BookDoc book;
  final VoidCallback onRecord;
  final VoidCallback onClose;

  const _BookInfoDialogContent({
    super.key,
    required this.book,
    required this.onRecord,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              // 책 제목
              SizedBox(
                width: 250, height: 50,
                child: Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textSize16.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              // 썸네일
              Image.network(book.thumbnail, width: 120),
              const SizedBox(height: 40),
              // 정보
              Column(
                children: [
                  Text(book.authors.join(", "), style: AppTextStyles.textSize16),
                  const SizedBox(height: 20),
                  Text(book.publisher, style: AppTextStyles.textSize16),
                ],
              ),
            ],
          ),
        ),
        // 버튼 바
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: PopupButton(
            buttonNumbers: 2,
            onTap_01: onRecord,
            onTap_02: onClose,
            buttonText_01: '기록하기',
            buttonText_02: '닫기',
          ),
        ),
      ],
    );
  }
}