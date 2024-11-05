class PlantTypeModel {
  final String? title;
  final String? categoryId;
  final String? thumbnailUrl;
  final String? resourceUrl;
  final String? mainImageUrl;

  PlantTypeModel({
    this.title,
    this.categoryId,
    this.thumbnailUrl,
    this.resourceUrl,
    this.mainImageUrl,
  });

  factory PlantTypeModel.fromJson(Map<String, dynamic> json) => PlantTypeModel(
        title: json["title"],
        categoryId: json["categoryId"],
        thumbnailUrl: json["thumbnailUrl"],
        resourceUrl: json["resourceUrl"],
        mainImageUrl: json["mainImageUrl"],
      );
}
