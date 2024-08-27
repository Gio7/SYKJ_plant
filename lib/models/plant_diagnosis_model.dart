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

  Plant({
    this.diseaseDetail,
    this.healthy,
    this.scientificName,
  });

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        diseaseDetail: json["diseaseDetail"] == null ? [] : List<DiseaseDetail>.from(json["diseaseDetail"]!.map((x) => DiseaseDetail.fromJson(x))),
        healthy: json["healthy"],
        scientificName: json["scientificName"],
      );
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
