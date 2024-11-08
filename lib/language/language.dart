import 'package:get/get.dart';

import 'language_da.dart';
import 'language_de.dart';
import 'language_en_us.dart';
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
import 'language_zh_cn.dart';
import 'language_zh_tw.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'zh_CN': LanguageZhCn.language,
      'zh_TW': LanguageZhTw.language,
      'en_US': LanguageEnUs.language,
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
      // 丹麦
      'da': LanguageDa.language,
      // 芬兰语
      'fi': LanguageFi.language,
      // 印尼语
      'id': LanguageId.language,
      // 马来西亚
      'ms': LanguageMs.language,
      // 挪威
      'no': LanguageNo.language,
      // 波兰语
      'pl': LanguagePl.language,
      // 罗马尼亚
      'ro': LanguageRo.language,
      // 俄语Ï
      'ru': LanguageRu.language,
      // 瑞典语
      'sv': LanguageSv.language,
      // 泰语
      'th': LanguageTh.language,
    };
  }
}
