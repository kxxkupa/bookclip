// ============================================
// Project: 북클립
// File: lib/data/datasources/remote/kakao_book_api.dart
// Role: 카카오 도서 API 호출
// Author: 김건우
// ============================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookclip/data/models/kakao_book.dart';

class KakaoBookApi {
  static const _host = 'dapi.kakao.com';
  static const _path = '/v3/search/book';
  
  final String _apiKey;
  KakaoBookApi({required String apiKey}) : _apiKey = apiKey;

  Future<KakaoBook> searchBooks({
    required String query,
    int page = 1,
    int size = 20,
    String sort = 'accuracy',
    String target = 'title',
    String url = 'url'
  }) async {
    if (_apiKey.isEmpty) {
      throw StateError('KAKAO_REST_API_KEY 누락');
    }
    if (query.isEmpty) {
      return KakaoBook(documents: const [], isEnd: true);
    }

    final uri = Uri.https(_host, _path, {
      'query': query,
      'page': '$page',
      'size': '$size',
      'sort': sort,
      'target': target,
      'url': url
    });

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'KakaoAK $_apiKey',
        },
      );

      if (response.statusCode == 200) {
        return KakaoBook.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('인증 실패(401): 키 확인');
      } else if (response.statusCode == 429) {
        throw Exception('호출 한도(429): 디바운스/캐싱 필요');
      } else {
        throw Exception('요청 실패(${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      // 네트워크 오류
      rethrow;
    }
  
  }
}