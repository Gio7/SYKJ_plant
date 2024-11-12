class CategorizedFeedModel {
  final int categoryId;
  final String categoryName;
  final String imageUrl;
  final List<CategorizedItem> item;

  CategorizedFeedModel({
    required this.categoryId,
    required this.categoryName,
    required this.imageUrl,
    required this.item,
  });

  factory CategorizedFeedModel.fromJson(Map<String, dynamic> json) => CategorizedFeedModel(
        categoryId: json["categoryId"] ?? '',
        categoryName: json["categoryName"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
        item: json["item"] == null ? [] : List<CategorizedItem>.from(json["item"]!.map((x) => CategorizedItem.fromJson(x))),
      );

  Map<String, dynamic> toMapDB() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imageUrl': imageUrl,
    };
  }
}

class CategorizedItem {
  final String? heading;
  final String? description;
  final String? thumbnailUrl;
  final String? resourceUrl;
  final int? feedType;
  final bool? important;

  CategorizedItem({
    this.heading,
    this.description,
    this.thumbnailUrl,
    this.resourceUrl,
    this.feedType,
    this.important,
  });

  factory CategorizedItem.fromJson(Map<String, dynamic> json) => CategorizedItem(
        heading: json["heading"],
        description: json["description"],
        thumbnailUrl: json["thumbnailUrl"],
        resourceUrl: json["resourceUrl"],
        feedType: json["feedType"],
        important: json["important"] is int ? json["important"] == 1 : json["important"],
      );

  Map<String, dynamic> toMapDB(int categoryId) {
    return {
      'heading': heading,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'resourceUrl': resourceUrl,
      'feedType': feedType,
      'important': important == true ? 1 : 0,
      'categoryId': categoryId,
    };
  }
}
