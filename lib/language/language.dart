import 'package:get/get.dart';
import 'package:plant/language/language_ar.dart';
import 'package:plant/language/language_de.dart';
import 'package:plant/language/language_es.dart';
import 'package:plant/language/language_fr.dart';
import 'package:plant/language/language_it.dart';
import 'package:plant/language/language_ja.dart';
import 'package:plant/language/language_ko.dart';
import 'package:plant/language/language_nl.dart';
import 'package:plant/language/language_pt.dart';
import 'package:plant/language/language_tr.dart';
import 'package:plant/language/language_zh_tw.dart';

import 'language_en_us.dart';
import 'language_zh_cn.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'zh_CN': LanguageZhCn.language,
      'zh_Hant_HK': LanguageZhTw.language,
      'zh_Hant_TW': LanguageZhTw.language,
      'zh_Hant_MO': LanguageZhTw.language,
      'en_US': LanguageEnUs.language,
      // 阿拉伯语
      'ar': LanguageAr.language,
      // 德语
      'de': LanguageDe.language,
      // 法语
      'fr': LanguageFr.language,
      // 西班牙语
      'es': LanguageEs.language,
      // 意大利语
      'it': LanguageIt.language,
      // 日语
      'ja': LanguageJa.language,
      // 韩语
      'ko': LanguageKo.language,
      // 荷兰语
      'nl': LanguageNl.language,
      // 葡萄牙语
      'pt': LanguagePt.language,
      // 土耳其
      'tr': LanguageTr.language,
    };
  }
}
