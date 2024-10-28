class PlantDiagnosisModel {
  final int? scanRecordId;
  final Plant? plant;

  PlantDiagnosisModel({
    this.scanRecordId,
    this.plant,
  });

  factory PlantDiagnosisModel.fromJson(Map<String, dynamic> json) => PlantDiagnosisModel(
        scanRecordId: json["scanRecordId"],
        plant: json["plant"] == null ? null : Plant.fromJson(json["plant"]),
      );
}

class Plant {
  final List<DiseaseDetail>? diseaseDetail;
  final bool? healthy;
  final String? scientificName;
  final String? name;
  final String? diagnoseImage;
  final DiagnoseDetect? diagnoseDetect;
  final List<Article>? article;

  Plant({
    this.diseaseDetail,
    this.healthy,
    this.scientificName,
    this.name,
    this.diagnoseImage,
    this.diagnoseDetect,
    this.article,
  });

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        diseaseDetail: json["diseaseDetail"] == null ? [] : List<DiseaseDetail>.from(json["diseaseDetail"]!.map((x) => DiseaseDetail.fromJson(x))),
        healthy: json["healthy"],
        scientificName: json["scientificName"],
        name: json["name"],
        diagnoseImage: json["diagnoseImage"],
        diagnoseDetect: json["diagnoseDetect"] == null ? null : DiagnoseDetect.fromJson(json["diagnoseDetect"]),
        article: json["article"] == null ? [] : List<Article>.from(json["article"]!.map((x) => Article.fromJson(x))),
      );
}

class DiagnoseDetect {
  final List<List<double>>? regions;

  DiagnoseDetect({
    this.regions,
  });

  factory DiagnoseDetect.fromJson(Map<String, dynamic> json) {
    return DiagnoseDetect(
      regions: json["regions"] == null
          ? []
          : List<List<double>>.from(
              json["regions"]!.map(
                (x1) => List<double>.from(
                  x1['region'].map(
                    (x2) => x2.toDouble(),
                  ),
                ),
              ),
            ),
    );
  }
}

class DiseaseDetail {
  final String? scientificDiseaseName;
  final String? diseaseName;
  final String? treatmentPlan;

  DiseaseDetail({
    this.scientificDiseaseName,
    this.diseaseName,
    this.treatmentPlan,
  });

  factory DiseaseDetail.fromJson(Map<String, dynamic> json) => DiseaseDetail(
        scientificDiseaseName: json["scientificDiseaseName"],
        diseaseName: json["diseaseName"],
        treatmentPlan: json["treatmentPlan"],
      );

  String get displayTitle => diseaseName ?? scientificDiseaseName ?? '';
}

class Article {
  final String title;
  final List<Content>? contents;

  Article({
    required this.title,
    this.contents,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json["title"] ?? '',
        contents: json["contents"] == null ? [] : List<Content>.from(json["contents"]!.map((x) => Content.fromJson(x))),
      );
}

class Content {
  ///0,1,2; 0取content, 1取Part, 2取imageUrl
  final int type;
  final String? content;
  final String? imageUrl;
  final Part? contentPart;

  Content({
    required this.type,
    this.content,
    this.imageUrl,
    this.contentPart,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        type: json["type"],
        content: json["content"],
        imageUrl: json["imageUrl"],
        contentPart: json["part"] == null ? null : Part.fromJson(json["part"]),
      );
}

class Part {
  final String? title;
  final String? content;

  Part({
    this.title,
    this.content,
  });

  factory Part.fromJson(Map<String, dynamic> json) => Part(
        title: json["title"],
        content: json["content"],
      );
}
