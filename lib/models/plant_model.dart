import 'package:intl/intl.dart';
import 'package:plant/common/date_util.dart';

class PlantModel {
  final dynamic createBy;
  final String? createTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final dynamic remark;
  final int? createTimestamp;
  final int? id;
  final int? uid;
  final String? thumbnail;
  final String? scientificName;
  String? plantName;
  final String? language;
  final int? status;

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
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) => PlantModel(
        createBy: json["createBy"],
        createTime: json["createTime"],
        updateBy: json["updateBy"],
        updateTime: json["updateTime"],
        remark: json["remark"],
        createTimestamp: json["createTimestamp"],
        id: json["id"],
        uid: json["uid"],
        thumbnail: json["thumbnail"],
        scientificName: json["scientificName"],
        plantName: json["plantName"],
        language: json["language"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "createBy": createBy,
        "createTime": createTime,
        "updateBy": updateBy,
        "updateTime": updateTime,
        "remark": remark,
        "createTimestamp": createTimestamp,
        "id": id,
        "uid": uid,
        "thumbnail": thumbnail,
        "scientificName": scientificName,
        "plantName": plantName,
        "language": language,
        "status": status,
      };

  String get createTimeLoacal {
    return DateUtil.formatString(createTime, format: DateFormat.yMd());
  }
}
