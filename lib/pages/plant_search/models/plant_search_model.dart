class PlantSearchModel {
  final String? uniqueId;
  final String? scientificName;
  final String? commonName;
  final String? aboutName;
  final List<String>? commonNamesList;
  final List<String>? alternativeNames;
  final String? primaryImageUrl;
  final int? hierarchyRank;
  final AdditionalInfo? additionalInfo;

  PlantSearchModel({
    this.uniqueId,
    this.scientificName,
    this.commonName,
    this.aboutName,
    this.commonNamesList,
    this.alternativeNames,
    this.primaryImageUrl,
    this.hierarchyRank,
    this.additionalInfo,
  });

  factory PlantSearchModel.fromJson(Map<String, dynamic> json) => PlantSearchModel(
        uniqueId: json["uniqueId"],
        scientificName: json["scientificName"],
        commonName: json["commonName"],
        aboutName: json["aboutName"],
        commonNamesList: json["commonNamesList"] == null ? [] : List<String>.from(json["commonNamesList"]!.map((x) => x)),
        alternativeNames: json["alternativeNames"] == null ? [] : List<String>.from(json["alternativeNames"]!.map((x) => x)),
        primaryImageUrl: json["primaryImageUrl"],
        hierarchyRank: json["hierarchyRank"],
        additionalInfo: json["additionalInfo"] == null ? null : AdditionalInfo.fromJson(json["additionalInfo"]),
      );
}

class AdditionalInfo {
  final PreferredCommonName? preferredCommonName;

  AdditionalInfo({
    this.preferredCommonName,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
        preferredCommonName: json["PreferredCommonName"] == null ? null : PreferredCommonName.fromJson(json["PreferredCommonName"]),
      );
}

class PreferredCommonName {
  final String? tagName;
  final String? type;
  final List<String>? value;
  final bool? withEdibleOrMedicinalInfo;

  PreferredCommonName({
    this.tagName,
    this.type,
    this.value,
    this.withEdibleOrMedicinalInfo,
  });

  factory PreferredCommonName.fromJson(Map<String, dynamic> json) => PreferredCommonName(
        tagName: json["tag_name"],
        type: json["type"],
        value: json["value"] == null ? [] : List<String>.from(json["value"]!.map((x) => x)),
        withEdibleOrMedicinalInfo: json["with_edible_or_medicinal_info"],
      );
}
