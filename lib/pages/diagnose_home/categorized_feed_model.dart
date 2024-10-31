class CategorizedFeedModel {
  final int categoryId;
  final String categoryName;
  final String imageUrl;
  final List<Item> item;

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
        item: json["item"] == null ? [] : List<Item>.from(json["item"]!.map((x) => Item.fromJson(x))),
      );
}

class Item {
  final String? heading;
  final String? description;
  final String? thumbnailUrl;
  final String? resourceUrl;
  final int? feedType;
  final bool? important;

  Item({
    this.heading,
    this.description,
    this.thumbnailUrl,
    this.resourceUrl,
    this.feedType,
    this.important,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        heading: json["heading"],
        description: json["description"],
        thumbnailUrl: json["thumbnailUrl"],
        resourceUrl: json["resourceUrl"],
        feedType: json["feedType"],
        important: json["important"],
      );
}
