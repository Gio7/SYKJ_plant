import 'package:intl/intl.dart';
import 'package:plant/common/date_util.dart';

class UserInfoModel {
  /// 时间戳
  final String? expireTime;
  final int? expireTimestamp;
  String? nickname;

  /// 会员类型 1=普通 2=周卡 3=月卡 4=年卡
  final int? memberType;
  final int? userid;
  final int? point;

  /// 是否永久会员
  final bool isLifetimeUser;

  UserInfoModel({
    this.expireTimestamp,
    this.expireTime,
    this.nickname,
    this.memberType,
    this.userid,
    this.point,
    this.isLifetimeUser = false,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        expireTime: json["expireTime"],
        expireTimestamp: json["expireTimestamp"],
        nickname: json["nickname"],
        memberType: json["memberType"],
        userid: json["userid"],
        point: json["point"],
        isLifetimeUser: json["isLifetimeUser"] ?? false,
      );

  toMap() => {
        "expireTime": expireTime,
        "expireTimestamp": expireTimestamp,
        "nickname": nickname,
        "memberType": memberType,
        "userid": userid,
        "point": point,
        "isLifetimeUser": isLifetimeUser,
      };

  bool get isRealVip {
    if (memberType != 1 && expireTimestamp != null) {
      if (expireTimestamp! > DateTime.now().millisecondsSinceEpoch) {
        return true;
      }
    }
    return false;
  }

  String get proExpirationDate {
    if (expireTimestamp == null) return '';
    return DateUtil.formatMilliseconds(expireTimestamp, format: DateFormat.yMd());
  }
}
