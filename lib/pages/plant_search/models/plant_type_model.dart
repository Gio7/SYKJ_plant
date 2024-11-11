class PlantTypeModel {
  final String? title;
  final String? categoryId;
  final String? thumbnailUrl;

  PlantTypeModel({
    this.title,
    this.categoryId,
    this.thumbnailUrl,
  });

  factory PlantTypeModel.fromJson(Map<String, dynamic> json) => PlantTypeModel(
        title: json["title"],
        categoryId: json["categoryId"],
        thumbnailUrl: json["thumbnailUrl"],
      );
}
