import 'package:intl/intl.dart';
import 'package:plant/common/date_util.dart';

class DiagnosisHistoryModel {
  final dynamic createBy;
  final String? createTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final String? remark;
  final int createTimestamp;
  final int? id;
  final int? uid;
  final String? thumbnail;
  final String? scientificName;
  final String? plantName;
  final String? language;
  final int? status;
  final int? type;
  final String? diseaseName;
  final String? diseaseScientificName;
  final String? mongoId;

  DiagnosisHistoryModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    required this.createTimestamp,
    this.id,
    this.uid,
    this.thumbnail,
    this.scientificName,
    this.plantName,
    this.language,
    this.status,
    this.type,
    this.diseaseName,
    this.diseaseScientificName,
    this.mongoId,
  });

  factory DiagnosisHistoryModel.fromJson(Map<String, dynamic> json) => DiagnosisHistoryModel(
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
        type: json["type"],
        diseaseName: json["diseaseName"],
        diseaseScientificName: json["diseaseScientificName"],
        mongoId: json["mongoId"],
      );

  String get createTimeLocal {
    return DateUtil.formatString(createTime, format: DateFormat.yMd());
  }

  String get createTimeYmd {
    return DateUtil.formatString(createTime, format: DateFormat("yyyyMMdd"));
  }
}
