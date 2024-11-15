import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:plant/common/global_data.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/language/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioUtil {
  static String token = '';

  static Dio? _dio;

  static bool hasNetwork = true;

  static bool resetDio() {
    _dio = null;
    DioUtil._init();
    return true;
  }

  /*
  version-name    //版本号
  Platform   //android或iOS
  region    //地区代码
  adId      //唯一设备ID
  language   //语言代码 
  */
  DioUtil._init() {
    final dl = Get.deviceLocale;
    String language = dl?.languageCode ?? '';
    final currentLanguage = Language().keys.keys.firstWhere(
          (element) => element.contains(language),
          orElse: () => '',
        );
    if (currentLanguage.isEmpty) {
      language = 'en';
    }
    // if (dl?.scriptCode != null && dl!.scriptCode!.isNotEmpty) {
    if (dl?.scriptCode == 'Hant') {
      language += '_${dl!.scriptCode}';
    }
    _dio = Dio(
      BaseOptions(
        baseUrl: GlobalData.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json,
        listFormat: ListFormat.multiCompatible,
        headers: {
          'Authorization': (GetUtils.isBlank(token) ?? true) ? null : token,
          'platform': GetPlatform.isAndroid ? 'android' : 'iOS',
          'version-name': GlobalData.versionName,
          'region': Get.deviceLocale?.countryCode,
          'adId': GlobalData.adId,
          'language': language,
        },
      ),
    )
      // ..interceptors.add(LogInterceptor())
      ..interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
  }

  static _showNetworkErrorToast() {
    Fluttertoast.showToast(
      msg: 'Network error. Please try again later.',
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 5,
      gravity: ToastGravity.CENTER,
    );
  }

  static _exceptionHandling(String? message, Response? response) {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    if (response?.statusCode == 401 || response?.statusCode == 403) {
      SharedPreferences.getInstance().then((value) {
        value.remove('token');
        token = '';
        resetDio();
      });
      UserController().showLogin();
    } else if (response?.statusCode == 500 && hasNetwork) {
      _showNetworkErrorToast();
      Get.log('Status Code 500: ${response?.statusMessage}');
    } else if (hasNetwork) {
      _showNetworkErrorToast();
      Get.log('Status Code:${response?.statusCode} ${message ?? response?.statusMessage ?? 'unknown error'}');
    }
  }

  /// get请求
  static dynamic httpGet(String url, {Map<String, dynamic>? parameters, bool allData = false}) async {
    try {
      var response = await _dio!.get(url, queryParameters: parameters);
      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData['code'] == 200 || responseData['code'] == 0) {
          if (allData) {
            return responseData;
          }
          return responseData['data'];
        } else if (responseData['code'] == 401 || responseData['code'] == 403) {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
          SharedPreferences.getInstance().then((value) {
            value.remove('token');
            token = '';
            resetDio();
          });
          UserController().showLogin();
        } else {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
          if (hasNetwork) {
            _showNetworkErrorToast();
            Get.log('${responseData['state'] ?? responseData['code']} ${responseData['msg'] ?? responseData['state'] ?? responseData['code'].toString()}');
          }
        }
      } else {
        _exceptionHandling(null, response);
      }
      throw response;
    } on DioException catch (e) {
      _exceptionHandling(e.message, e.response);
      rethrow;
    }
  }

  /// post请求
  static Future<dynamic> httpPost(String url, {required Map<String, dynamic> data, bool allData = false, bool ignore208 = false, bool ignoreAll = false}) async {
    try {
      var response = await _dio!.post(url, data: data);
      if (ignoreAll) {
        return response;
      }
      if (response.statusCode == 200) {
        var responseData = response.data;
        if (ignore208 && responseData['code'] == 208) {
          return responseData['data'];
        }
        if (responseData['code'] == 200 || responseData['code'] == 0) {
          return responseData['data'];
        } else if (responseData['code'] == 401 || responseData['code'] == 403) {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
          SharedPreferences.getInstance().then((value) {
            value.remove('token');
            token = '';
            resetDio();
          });
          UserController().showLogin();
        } else {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
          if (hasNetwork) {
            _showNetworkErrorToast();
            Get.log('${responseData['state'] ?? responseData['code']} ${responseData['msg'] ?? responseData['state'] ?? responseData['code'].toString()}');
          }
        }
      } else {
        _exceptionHandling(null, response);
      }
      throw response;
    } on DioException catch (e) {
      _exceptionHandling(e.message, e.response);
      rethrow;
    }
  }
}
