import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class Common {
  static Function() debounce(Function fn, [int t = 500]) {
    Timer? debounce;
    return () {
      if (debounce?.isActive ?? false) {
        debounce?.cancel();
      } else {
        fn();
      }
      debounce = Timer(Duration(milliseconds: t), () {
        debounce?.cancel();
        debounce = null;
      });
    };
  }

  static Future<void> skipUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      throw Exception('url null');
    }
    try {
      final url = Uri.parse(urlString);
      final bool isSul = await launchUrl(
        url,
      );
      if (!isSul) {
        // Get.snackbar('error', 'fail');
        throw Exception('fail');
      }
    } catch (e) {
      Fluttertoast.showToast(msg:  'open error', gravity: ToastGravity.CENTER);
      rethrow;
    }
  }
}
