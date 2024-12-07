import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
import 'common/buy_engine.dart';
import 'common/firebase_message.dart';
import 'common/firebase_util.dart';
import 'common/ui_color.dart';
import 'router/app_pages.dart';
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
    // 锁定竖屏
    // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await initMain();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {
      // Get.log('network status list: ${result.length}');
      // for (var element in result) {
      //   Get.log('network status changed: ${element.name}');
      // }
      if (result.contains(ConnectivityResult.none)) {
        DioUtil.hasNetwork = false;
        Get.log('No network connection.', isError: true);
      } else {
        DioUtil.hasNetwork = true;
        if (GlobalData.email.isEmpty) {
          getConfig();
        }
        if (isInit) {
          isInit = false;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
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
    if (kDebugMode) {
      FlutterError.onError = (FlutterErrorDetails details) {
        Get.log(" ----捕获到同步异常---- \n${details.exceptionAsString()}\n\nStack Trace:\n${details.stack}", isError: true);
      };
    } else {
      // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      FlutterError.onError = (FlutterErrorDetails details) {
        FireBaseUtil.logEvent('FlutterError', parameters: {
          'exception': _truncateString(details.exceptionAsString(), 99),
          'stack': _truncateString("${details.stack}", 99),
        });
      };
    }
    FlutterNativeSplash.remove();
    runApp(const MainApp());
  }, (error, stackTrace) {
    if (kDebugMode) {
      Get.log(" ----捕获到异步异常---- \n$error\n\nStack Trace:\n$stackTrace", isError: true);
    } else {
      // FirebaseCrashlytics.instance.recordError(error, stackTrace);
      FireBaseUtil.logEvent('FlutterError', parameters: {
        'exception': _truncateString("$error", 99),
        'stack': _truncateString("$stackTrace", 99),
      });
    }
  });
}

String _truncateString(String str, int length) {
  if (str.length <= length) {
    return str;
  } else {
    return str.substring(0, length);
  }
}

Future<void> initMain() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    Get.log('firebase init error: $e');
  }
  FireBaseUtil.initAnalyticsServices();

  EasyRefreshCustom.setup();
  try {
    final info = await PackageInfo.fromPlatform();
    GlobalData.versionName = info.version;
    GlobalData.packageName = info.packageName;
  } catch (e) {
    Get.log('PackageInfo init error: $e');
  }

  try {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      DioUtil.token = token;
    }
  } catch (e) {
    Get.log('SharedPreferences init error: $e');
  }

  DioUtil.resetDio();
  final buy = BuyEngine();
  buy.initialize();
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
      FirebaseMessage().init();
    }
  } catch (e) {
    Get.log("fcm error: $e", isError: true);
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const fallbackLocale = Locale('en');
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant Identifier',
      themeMode: ThemeMode.dark,
      initialBinding: CoreBindingController(),
      translations: Language(),
      locale: adjustLocale(Get.deviceLocale ?? fallbackLocale),
      fallbackLocale: const Locale('en'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [adjustLocale(Get.deviceLocale ?? fallbackLocale)],
      navigatorObservers: FireBaseUtil.observer == null ? [] : [FireBaseUtil.observer!],
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
      initialRoute: '/',
      getPages: AppPages.routes,
    );
  }

  Locale adjustLocale(Locale deviceLocale) {
    if (deviceLocale.scriptCode == 'Hant') {
      return const Locale('zh', 'Hant');
    } else if (deviceLocale.scriptCode == 'Hans') {
      return const Locale('zh', 'Hans');
    }
    return deviceLocale;
  }
}
