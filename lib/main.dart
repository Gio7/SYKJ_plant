import 'dart:async';

import 'package:advertising_id/advertising_id.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/global_data.dart';
import 'package:plant/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/dio.dart';
import 'common/firebase_util.dart';
import 'common/ui_color.dart';
import 'widgets/easy_refresh_custom.dart';
import 'controllers/core_binding.dart';
import 'language/language.dart';
import 'pages/main_page.dart';

void main() {
  // 拦截异步错误
  runZonedGuarded(() async {
    bool isInit = true;
    // WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
          WidgetsBinding.instance.addPostFrameCallback((_) async{
            await getAdid();
            getFCMToken();
          });
        }
      }
    });

    // ErrorWidget.builder = (FlutterErrorDetails details) {
    //   return Center(
    //     child: Stack(
    //       alignment: Alignment.bottomCenter,
    //       children: [
    //         Image.asset('images/icon/unknow_error_bg.png'),
    //         ElevatedButton.icon(
    //           onPressed: () async{
    //             await Clipboard.setData(ClipboardData(text: "${details.exceptionAsString()}\n\nStack Trace:\n${details.stack}"));
    //             Common.skipUrl(GlobalData.telegramGroup);
    //           },
    //           label: const Text('Telegram'),
    //           icon: Image.asset('images/icon/telegram.png', height: 24),
    //         ),
    //       ],
    //     ),
    //   );
    // };

    // 拦截同步错误
    FlutterError.onError = (FlutterErrorDetails details) {
      Get.log(" ----捕获到同步异常---- \n${details.exceptionAsString()}\n\nStack Trace:\n${details.stack}", isError: true);
    };
    FlutterNativeSplash.remove();
    runApp(const MainApp());
  }, (error, stackTrace) {
    Get.log(" ----捕获到异步异常---- \n$error\n\nStack Trace:\n$stackTrace", isError: true);
  });
}

Future<void> initMain() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FireBaseUtil.initAnalyticsServices();
  } catch (e) {
    Get.log('Firebase initialization error: $e');
  }
  EasyRefreshCustom.setup();
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
    Get.log("adid error: $e", isError: true);
    // advertisingId = 'Failed to get platform version.';
  }
}

Future<void> getFCMToken() async {
  try {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      GlobalData.fcmToken = fcmToken;
    }
  } catch (e) {
    Get.log("fcm error: $e", isError: true);
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
