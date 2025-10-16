import 'package:bookclip/common/const/public_style.dart';
import 'package:bookclip/common/env/env.dart';
import 'package:bookclip/common/screen/app_page.dart';
import 'package:bookclip/menu_home/page_main.dart';
import 'package:bookclip/menu_library/page_library.dart';
import 'package:bookclip/menu_setting/page_setting.dart';
import 'package:bookclip/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 한국어 날짜 포맷 초기화
  await initializeDateFormatting('ko_KR', '');

  // .env.dev 로드 시도
  await Env.init();

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: (settings) {
        Widget page;

        switch(settings.name){
          case homeRoute:
            page = const PageMain();
            break;
          case libraryRoute:
            page = const PageLibrary();
            break;
          case settingRoute:
            page = const PageSetting();
            break;
          default:
            page = const AppPage();
            break;
        }

        return MaterialPageRoute(
          builder: (_) => AppPage(),
          settings: settings,
        );
      },
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      home: const AppPage(),
    );
  }
}