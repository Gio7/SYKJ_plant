import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plant/common/global_data.dart';
import 'package:plant/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/dio.dart';
import 'common/ui_color.dart';
import 'components/easy_refresh_custom.dart';
import 'controllers/core_binding.dart';
import 'language/language.dart';
import 'pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }
  await initMain();
  runApp(const MainApp());
}

Future<void> initMain() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  EasyRefreshCustom.setup();
  // FireBaseUtil.initAnalyticsServices();
  final info = await PackageInfo.fromPlatform();
  GlobalData.versionName = info.version;
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  if (token != null) {
    DioUtil.token = token;
  }
  DioUtil.resetDio();

  // GlobalData.buyShop.initializeInAppPurchase();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Lab',
      themeMode: ThemeMode.dark,
      initialBinding: CoreBindingController(),
      translations: Language(),
      locale: Get.deviceLocale, //const Locale('zh', 'CN'),
      fallbackLocale: const Locale('en', 'US'),
      // navigatorObservers: [FireBaseUtil.observer],
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: UIColor.primary),
        useMaterial3: true,
        splashColor: Colors.transparent,
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          backgroundColor: UIColor.white,
          shadowColor: UIColor.white,
          surfaceTintColor: UIColor.white,
        ),
      ),
      home: const MainPage(),
    );
  }
}
