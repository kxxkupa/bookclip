import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  // 앱 시작 시 1회 호출 (개발: .env.dev 로드, 배포: dart-define만 써도 OK)
  static Future<void> init({String devEnvFile = '.env.dev'}) async {
    await dotenv.load(fileName: devEnvFile).catchError((_) => null);
  }

  // 카카오 키: dart-define 우선, 없으면 dotenv에서
  static String get kakaoKey {
    const fromDefine = String.fromEnvironment('KAKAO_REST_API_KEY');
    if (fromDefine.isNotEmpty) return fromDefine;

    final fromDotenv = dotenv.env['KAKAO_REST_API_KEY'] ?? '';
    if (fromDotenv.isEmpty) {
      throw StateError(
        'KAKAO_REST_API_KEY 누락. '
        '개발: .env.dev 파일 확인 / 배포: --dart-define=KAKAO_REST_API_KEY=...'
      );
    }
    return fromDotenv;
  }
}