import 'package:get/get.dart';

import 'language_da.dart';
import 'language_de.dart';
import 'language_en.dart';
import 'language_es.dart';
import 'language_fi.dart';
import 'language_fr.dart';
import 'language_id.dart';
import 'language_it.dart';
import 'language_ja.dart';
import 'language_ko.dart';
import 'language_ms.dart';
import 'language_nl.dart';
import 'language_no.dart';
import 'language_pl.dart';
import 'language_pt.dart';
import 'language_ro.dart';
import 'language_ru.dart';
import 'language_sv.dart';
import 'language_th.dart';
import 'language_tr.dart';
import 'language_zh_hans.dart';
import 'language_zh_hant.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'zh_Hant': LanguageZhHant.language, // 繁体中文
      'zh_Hans': LanguageZhHans.language, // 简体中文
      'zh': LanguageZhHans.language, // 简体中文
      'en': LanguageEn.language, // 英文
      'de': LanguageDe.language, // 德语
      'fr': LanguageFr.language, // 法语
      'es': LanguageEs.language, // 西班牙语
      'it': LanguageIt.language, // 意大利语
      'ja': LanguageJa.language, // 日语
      'ko': LanguageKo.language, // 韩语
      'nl': LanguageNl.language, // 荷兰语
      'pt': LanguagePt.language, // 葡萄牙语
      'tr': LanguageTr.language, // 土耳其语
      'da': LanguageDa.language, // 丹麦语
      'fi': LanguageFi.language, // 芬兰语
      'id': LanguageId.language, // 印尼语
      'ms': LanguageMs.language, // 马来语
      'no': LanguageNo.language, // 挪威语
      'pl': LanguagePl.language, // 波兰语
      'ro': LanguageRo.language, // 罗马尼亚语
      'ru': LanguageRu.language, // 俄语
      'sv': LanguageSv.language, // 瑞典语
      'th': LanguageTh.language, // 泰语
    };
  }
}
