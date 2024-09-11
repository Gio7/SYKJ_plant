import 'package:advertising_id/advertising_id.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/global_data.dart';
import 'package:plant/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/dio.dart';
import 'common/firebase_util.dart';
import 'common/ui_color.dart';
import 'components/easy_refresh_custom.dart';
import 'controllers/core_binding.dart';
import 'language/language.dart';
import 'pages/main_page.dart';

Future<void> main() async {
  bool isInit = true;
  WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }
  await initMain();
  Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {
    // Get.log('network status list: ${result.length}');
    // for (var element in result) {
    //   Get.log('network status changed: ${element.name}');
    // }
    if (result.contains(ConnectivityResult.none)) {
      Get.log('No network connection.', isError: true);
    } else {
      if (GlobalData.email.isEmpty) {
        getConfig();
      }
      if (isInit) {
        isInit = false;
        WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) => getAdid());
      }
    }
  });
  runApp(const MainApp());
}

Future<void> initMain() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    Get.log('Firebase initialization error: $e');
  }
  EasyRefreshCustom.setup();
  FireBaseUtil.initAnalyticsServices();
  final info = await PackageInfo.fromPlatform();
  GlobalData.versionName = info.version;
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  if (token != null) {
    DioUtil.token = token;
  }
  DioUtil.resetDio();
  GlobalData.buyShop.initializeInAppPurchase();
}

Future<void> getConfig() async {
  final list = await Request.getConfig();
  for (final item in (list as List)) {
    if (item['conKey'] == 'telegram_group') {
      GlobalData.telegramGroup = item['conValue'];
    } else if (item['conKey'] == 'email') {
      GlobalData.email = item['conValue'];
    }
  }
}

Future<void> getAdid() async {
  await Future.delayed(const Duration(milliseconds: 1500));
  try {
    GlobalData.adId = await AdvertisingId.id(true) ?? '';
    if (GlobalData.adId.isNotEmpty) {
      DioUtil.resetDio();
    }
  } catch (e) {
    Get.log(e.toString(), isError: true);
    // advertisingId = 'Failed to get platform version.';
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant Identifier',
      themeMode: ThemeMode.dark,
      initialBinding: CoreBindingController(),
      translations: Language(),
      locale: _parseLocale(Get.deviceLocale ?? const Locale('en', 'US')),
      fallbackLocale: const Locale('en', 'US'),
      navigatorObservers: [FireBaseUtil.observer],
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

  Locale _parseLocale(Locale locale) {
    if (locale.scriptCode == 'Hans') {
      return const Locale('zh', 'CN');
    } else if (locale.scriptCode == 'Hant') {
      return const Locale('zh', 'TW');
    }
    return locale;
  }
}
