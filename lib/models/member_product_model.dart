import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class MemberProductModel with EquatableMixin {
  final dynamic createBy;
  final dynamic createTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final dynamic remark;
  final int? createTimestamp;
  final int? id;
  final int? point;
  /// 1 = 非会员 2 = 周卡 3 = 年卡
  final int? memberType;
  final int? shopType;
  final String? shopId;
  final String? shopName;
  final double? price;
  final dynamic number;
  final dynamic shopDescribe;
  final bool? selected;
  final int? status;
  ProductDetails? productDetails;

  final bool isFreeTrial;

  MemberProductModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.createTimestamp,
    this.id,
    this.point,
    this.memberType,
    this.shopType,
    this.shopId,
    this.shopName,
    this.price,
    this.number,
    this.shopDescribe,
    this.selected,
    this.status,
    this.isFreeTrial = false,
  });

  factory MemberProductModel.fromJson(Map<String, dynamic> json, {bool isTrial = false}) => MemberProductModel(
        createBy: json["createBy"],
        createTime: json["createTime"],
        updateBy: json["updateBy"],
        updateTime: json["updateTime"],
        remark: json["remark"],
        createTimestamp: json["createTimestamp"],
        id: json["id"],
        point: json["point"],
        memberType: json["memberType"],
        shopType: json["shopType"],
        shopId: json["shopId"],
        shopName: json["shopName"],
        price: json["price"]?.toDouble(),
        number: json["number"],
        shopDescribe: json["shopDescribe"],
        selected: json["selected"],
        status: json["status"],
        isFreeTrial: json["trial"],
      );

  @override
  List<Object?> get props => [id];

  String get unitStr {
    final price = productDetails?.price ?? '';
    String unit = '';
    if (productDetails?.id == 'plant_sub_vip_plan_weekly' || productDetails?.id == 'sub_vip_plan_weekly' || productDetails?.id == 'vip_plan_weekly_sub') {
      unit = 'week'.tr;
    } else if (productDetails?.id == 'sub_vip_plan_yearly' || productDetails?.id == 'plant_sub_vip_plan_yearly' || productDetails?.id == 'vip_plan_yearly_sub') {
      unit = 'year'.tr;
    }
    if (unit.isNotEmpty) {
      return '$price/$unit';
    }
    return price;
  }

  String get unitSingleStr {
    String unit = '';
    if (productDetails?.id == 'plant_sub_vip_plan_weekly' || productDetails?.id == 'sub_vip_plan_weekly' || productDetails?.id == 'vip_plan_weekly_sub') {
      unit = 'weekly'.tr;
    } else if (productDetails?.id == 'sub_vip_plan_yearly' || productDetails?.id == 'plant_sub_vip_plan_yearly' || productDetails?.id == 'vip_plan_yearly_sub') {
      unit = 'yearly'.tr;
    }
    return unit;
  }
}
