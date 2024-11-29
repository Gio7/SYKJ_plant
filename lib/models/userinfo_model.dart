import 'package:intl/intl.dart';
import 'package:plant/common/date_util.dart';

/// 会员类型
enum MemberType {
  /// 非会员
  normal(1),

  /// 周卡
  weekly(2),

  /// 年卡
  yearly(3);

  const MemberType(this.value);
  final int value;

  static MemberType fromValue(int? value) {
    switch (value) {
      case 1:
        return MemberType.normal;
      case 2:
        return MemberType.weekly;
      case 3:
        return MemberType.yearly;
      default:
        return MemberType.normal;
    }
  }
}

class UserInfoModel {
  /// 时间戳
  final String? expireTime;
  final int? expireTimestamp;
  String? nickname;

  final MemberType? memberType;
  final int? userid;
  final int? point;

  final bool isVip;

  final bool pushToken;

  UserInfoModel({
    this.expireTimestamp,
    this.expireTime,
    this.nickname,
    this.memberType,
    this.userid,
    this.point,
    this.isVip = false,
    this.pushToken = false,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    bool vip = json["isVip"] ?? false;
    final expireTimestamp = json["expireTimestamp"];
    if (expireTimestamp == null) {
      vip = false;
    } else {
      vip = expireTimestamp > DateTime.now().millisecondsSinceEpoch;
    }
    return UserInfoModel(
      expireTime: json["expireTime"],
      expireTimestamp: expireTimestamp,
      nickname: json["nickname"],
      memberType: MemberType.fromValue(json["memberType"]),
      userid: json["userid"],
      point: json["point"],
      isVip: vip,
      pushToken: json["pushToken"] ?? false,
    );
  }

  toMap() => {
        "expireTime": expireTime,
        "expireTimestamp": expireTimestamp,
        "nickname": nickname,
        "memberType": memberType?.value,
        "userid": userid,
        "point": point,
        "isVip": isVip,
        "pushToken": pushToken
      };

  bool get isRealVip {
    if (isVip && memberType != MemberType.normal && expireTimestamp != null) {
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
