import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plant/common/date_util.dart';

import 'reminder_model.dart';

class PlantModel {
  final dynamic createBy;
  final String? createTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final dynamic remark;
  final int createTimestamp;
  // 植物记录ID (植物列表返回的)
  final int? id;
  final int? uid;
  final String? thumbnail;
  final String? scientificName;
  String? plantName;
  final String? language;
  final int? status;
  final List<TimedPlan>? timedPlans;

  PlantModel({
    required this.createBy,
    required this.createTime,
    required this.updateBy,
    required this.updateTime,
    required this.remark,
    required this.createTimestamp,
    required this.id,
    required this.uid,
    required this.thumbnail,
    required this.scientificName,
    required this.plantName,
    required this.language,
    required this.status,
    this.timedPlans,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) => PlantModel(
        createBy: json["createBy"],
        createTime: json["createTime"],
        updateBy: json["updateBy"],
        updateTime: json["updateTime"],
        remark: json["remark"],
        createTimestamp: json["createTimestamp"] ?? 0,
        id: json["id"],
        uid: json["uid"],
        thumbnail: json["thumbnail"],
        scientificName: json["scientificName"],
        plantName: json["plantName"],
        language: json["language"],
        status: json["status"],
        timedPlans: json["timedPlans"] == null ? [] : List<TimedPlan>.from(json["timedPlans"]!.map((x) => TimedPlan.fromJson(x))),
      );

  String get createTimeLocal {
    return DateUtil.formatString(createTime, format: DateFormat.yMd());
  }

  String get createTimeYmd {
    return DateUtil.formatString(createTime, format: DateFormat("yyyyMMdd"));
  }

  String get getReminderSetText {
    if (timedPlans == null || timedPlans!.isEmpty) return 'noReminder'.tr;
    String text = "reminderSet".tr;
    return text.replaceAll('9', timedPlans!.length.toString());
  }
}
