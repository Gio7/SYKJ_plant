class UserInfoModel {
  /// 时间戳
  final int? expireTime;
  final String? nickname;

  /// 会员类型 1=普通 2=周卡 3=月卡 4=年卡
  final int? memberType;
  final int? userid;
  final int? point;
  bool isVip;

  /// 是否永久会员
  bool isForever;

  /// 是否无限积分
  bool isInfinitePoint;

  UserInfoModel({
    this.expireTime,
    this.nickname,
    this.memberType,
    this.userid,
    this.point,
    this.isVip = false,
    this.isForever = false,
    this.isInfinitePoint = false,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        expireTime: json["expireTime"],
        nickname: json["nickname"],
        memberType: json["memberType"],
        userid: json["userid"],
        point: json["point"],
        isVip: json["isVip"] ?? false,
        isForever: json['isForever'] ?? false,
        isInfinitePoint: json['isInfinitePoint'] ?? false,
      );

  bool get isRealVip {
    if (isVip && expireTime != null) {
      if (expireTime! > DateTime.now().millisecondsSinceEpoch) {
        return true;
      }
    }
    return false;
  }
}
