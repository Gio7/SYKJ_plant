import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ReminderModel {
  final List<Record> records;
  final String date;

  ReminderModel({
    required this.records,
    required this.date,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
        records: json["records"] == null ? [] : List<Record>.from(json["records"]!.map((x) => Record.fromJson(x))),
        date: json["date"] ?? '',
      );
}

class Record {
  /// 0浇水 1加湿 2施肥 3转向
  final int type;
  final String? typeName;
  final List<TimedPlan> items;
  bool isExpanded;

  Record({
    required this.type,
    this.typeName,
    required this.items,
    this.isExpanded = false,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        type: json["type"],
        typeName: json["typeName"],
        items: json["items"] == null ? [] : List<TimedPlan>.from(json["items"]!.map((x) => TimedPlan.fromJson(x))),
      );

  String get getTypeIcon {
    switch (type) {
      case 0:
        return 'images/icon/water.png';
      case 1:
        return 'images/icon/atomizing.png';
      case 2:
        return 'images/icon/fertilizer.png';
      case 3:
        return 'images/icon/rotate.png';
      default:
        return 'images/icon/water.png';
    }
  }

  String get getTypeText {
    switch (type) {
      case 0:
        return 'watering'.tr;
      case 1:
        return 'misting'.tr;
      case 2:
        return 'fertilizing'.tr;
      case 3:
        return 'rotating'.tr;
      default:
        return 'watering'.tr;
    }
  }

  String get getItemsCount {
    String text = "plants".tr;
    return text.replaceAll('9', items.length.toString());
  }
}

class TimedPlan {
  final String? createTime;
  final DateTime updateTime;
  final int? createTimestamp;
  final int? id;

  /// 0浇水 1加湿 2施肥 3转向
  final int? type;

  /// 周期值
  final int? cycle;

  /// 周期单位 day week month
  final String? unit;

  /// 时间
  final String? clock;
  final String? previousTime;
  final int? previousTimestamp;
  final int? pushTime;
  final int? lastTime;
  final bool status;
  final String? thumbnail;
  final String? scientificName;
  final String? plantName;

  TimedPlan({
    this.createTime,
    required this.updateTime,
    this.createTimestamp,
    this.id,
    this.type,
    this.cycle,
    this.unit,
    this.clock,
    this.previousTime,
    this.previousTimestamp,
    this.pushTime,
    this.lastTime,
    required this.status,
    this.thumbnail,
    this.scientificName,
    this.plantName,
  });

  factory TimedPlan.fromJson(Map<String, dynamic> json) => TimedPlan(
        createTime: json["createTime"],
        updateTime: json["updateTime"] == null ? DateTime.now() : DateTime.parse(json["updateTime"]),
        createTimestamp: json["createTimestamp"],
        id: json["id"],
        type: json["type"],
        cycle: json["cycle"],
        unit: json["unit"],
        clock: json["clock"],
        previousTime: json["previousTime"],
        previousTimestamp: json["previousTimestamp"],
        pushTime: json["pushTime"],
        lastTime: json["lastTime"],
        status: json["status"] ?? false,
        thumbnail: json["thumbnail"],
        scientificName: json["scientificName"],
        plantName: json["plantName"],
      );

  String get getTypeIcon {
    switch (type) {
      case 0:
        return 'images/icon/water.png';
      case 1:
        return 'images/icon/atomizing.png';
      case 2:
        return 'images/icon/fertilizer.png';
      case 3:
        return 'images/icon/rotate.png';
      default:
        return 'images/icon/water.png';
    }
  }

  String get getCycleText {
    String text = "everyDays".tr;
    switch (unit) {
      case "day":
        text = "everyDays".tr;
      case "week":
        text = "everyWeeks".tr;
      case "month":
        text = "everyMonth".tr;
      default:
        text = "everyDays".tr;
    }
    return text.replaceAll('9', cycle.toString());
  }

  static String getUnitText(String cycle) {
    switch (cycle) {
      case "day":
        return "days".tr;
      case "week":
        return "weeks".tr;
      case "month":
        return "months".tr;
      default:
        return "days".tr;
    }
  }
}
