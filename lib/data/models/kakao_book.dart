// ============================================
// Project: 북클립
// File: lib/data/models/kakao_book.dart
// Role: 카카오 도서 API 모델
// Author: 김건우
// ============================================

class KakaoBook {
  final List<BookDoc> documents;
  final bool isEnd;
  KakaoBook({required this.documents, required this.isEnd});

  factory KakaoBook.fromJson(Map<String, dynamic> json) {
    return KakaoBook(
      documents: (json['documents'] as List).map((e) => BookDoc.fromJson(e)).toList(),
      isEnd: (json['meta']?['is_end'] as bool?) ?? true,
    );
  }
}

class BookDoc {
  final String title;
  final List<String> authors;
  final String publisher;
  final String isbn;
  final String thumbnail;
  final String contents;

  BookDoc({
    required this.title,
    required this.authors,
    required this.publisher,
    required this.isbn,
    required this.thumbnail,
    required this.contents,
  });

  factory BookDoc.fromJson(Map<String, dynamic> json) => BookDoc(
    title: json['title'] ?? '',
    authors: (json['authors'] as List?)?.cast<String>() ?? const [],
    publisher: json['publisher'] ?? '',
    isbn: json['isbn'] ?? '',
    thumbnail: json['thumbnail'] ?? '',
    contents: json['contents'] ?? '',
  );
}