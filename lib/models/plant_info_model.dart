import 'package:get/get.dart';

class PlantInfoModel {
  final int? scanRecordId;
  final Plant? plant;

  PlantInfoModel({
    this.scanRecordId,
    this.plant,
  });

  factory PlantInfoModel.fromJson(Map<String, dynamic> json) => PlantInfoModel(
        scanRecordId: json["scanRecordId"],
        plant: json["plant"] == null ? null : Plant.fromJson(json["plant"]),
      );

  factory PlantInfoModel.fromJsonBySearch(Map<String, dynamic> json) => PlantInfoModel(plant: Plant.fromJson(json));
}

class Plant {
  final String? id;
  final String? plantName;
  final String? thumbnail;
  final String? scientificName;
  final ScientificClassification? scientificClassification;
  final String? mainCharacteristics;
  final String? culturalSignificance;
  final Characteristics? characteristics;
  final Conditions? conditions;
  final List<Description>? description;
  final HowTos? howTos;
  final String? littleStory;

  Plant({
    this.id,
    this.plantName,
    this.thumbnail,
    this.scientificName,
    this.scientificClassification,
    this.mainCharacteristics,
    this.culturalSignificance,
    this.characteristics,
    this.conditions,
    this.description,
    this.howTos,
    this.littleStory,
  });

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        id: json["_id"],
        plantName: json["plantName"],
        thumbnail: json["thumbnail"],
        scientificName: json["scientificName"],
        scientificClassification: json["scientificClassification"] == null ? null : ScientificClassification.fromJson(json["scientificClassification"]),
        mainCharacteristics: json["mainCharacteristics"],
        culturalSignificance: json["culturalSignificance"],
        characteristics: json["characteristics"] == null ? null : Characteristics.fromJson(json["characteristics"]),
        conditions: json["conditions"] == null ? null : Conditions.fromJson(json["conditions"]),
        description: json["description"] == null ? [] : List<Description>.from(json["description"]!.map((x) => Description.fromJson(x))),
        howTos: json["howTos"] == null ? null : HowTos.fromJson(json["howTos"]),
        littleStory: json["littleStory"],
      );
}

class Characteristics {
  final Flower? flower;
  final Fruit? fruit;
  final MaturePlant? maturePlant;

  Characteristics({
    this.flower,
    this.fruit,
    this.maturePlant,
  });

  factory Characteristics.fromJson(Map<String, dynamic> json) => Characteristics(
        flower: json["flower"] == null ? null : Flower.fromJson(json["flower"]),
        fruit: json["fruit"] == null ? null : Fruit.fromJson(json["fruit"]),
        maturePlant: json["maturePlant"] == null ? null : MaturePlant.fromJson(json["maturePlant"]),
      );
}

class Flower {
  final String? flowerColor;
  final String? flowerSize;
  final List<Detail>? details;

  Flower({
    this.flowerColor,
    this.flowerSize,
    this.details,
  });

  factory Flower.fromJson(Map<String, dynamic> json) {
    List<Detail>? details = json["details"] == null ? null : List<Detail>.from(json["details"]!.map((x) => Detail.fromJson(x)));
    if (json["flowerSize"] != null || json["flowerColor"] != null) {
      details ??= [
        Detail(type: 'String', title: 'flowerSize'.tr, value: json["flowerSize"]),
        Detail(type: 'Colors', title: 'flowerColor'.tr, colors: json["flowerColor"]),
      ];
    }
    return Flower(
      flowerColor: json["flowerColor"],
      flowerSize: json["flowerSize"],
      details: details,
    );
  }
}

class Fruit {
  final String? fruitColor;
  final String? fruitRipeningTime;
  final List<Detail>? details;

  Fruit({
    this.fruitColor,
    this.fruitRipeningTime,
    this.details,
  });

  factory Fruit.fromJson(Map<String, dynamic> json) {
    List<Detail>? details = json["details"] == null ? null : List<Detail>.from(json["details"]!.map((x) => Detail.fromJson(x)));
    if (json["fruitRipeningTime"] != null || json["fruitColor"] != null) {
      details ??= [
        Detail(type: 'String', title: 'harvestTime'.tr, value: json["fruitRipeningTime"]),
        Detail(type: 'Colors', title: 'fruitColor'.tr, colors: json["fruitColor"]),
      ];
    }
    return Fruit(
      fruitColor: json["fruitColor"],
      fruitRipeningTime: json["fruitRipeningTime"],
      details: details,
    );
  }
}

class MaturePlant {
  final String? leafColor;
  final String? plantHeight;
  final String? spread;
  final List<Detail>? details;

  MaturePlant({
    this.leafColor,
    this.plantHeight,
    this.spread,
    this.details,
  });

  factory MaturePlant.fromJson(Map<String, dynamic> json) {
    List<Detail>? details = json["details"] == null ? null : List<Detail>.from(json["details"]!.map((x) => Detail.fromJson(x)));

    if (json["plantHeight"] != null || json["spread"] != null || json["leafColor"] != null) {
      details ??= [
        Detail(type: 'String', title: 'plantHeight'.tr, value: json["plantHeight"]),
        Detail(type: 'String', title: 'spread'.tr, value: json["spread"]),
        Detail(type: 'Colors', title: 'leafColor'.tr, colors: json["leafColor"]),
      ];
    }

    return MaturePlant(
      leafColor: json["leafColor"],
      plantHeight: json["plantHeight"],
      spread: json["spread"],
      details: details,
    );
  }
}

class Detail {
  final String? type;
  final String? title;
  final dynamic value;
  final String? originEnumValue;
  final String? colors;

  Detail({
    this.type,
    this.title,
    this.value,
    this.originEnumValue,
    this.colors,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        type: json["type"],
        title: json["title"],
        value: json["value"],
        originEnumValue: json["originEnumValue"],
        colors: json["colors"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
        "value": value,
        "originEnumValue": originEnumValue,
        "colors": colors,
      };
}

class Conditions {
  final String? sunlight;
  final String? location;
  final String? plantingSeason;
  final String? temperatureRange;
  final String? soilComposition;
  final String? hardiness;

  Conditions({
    this.sunlight,
    this.location,
    this.plantingSeason,
    this.temperatureRange,
    this.soilComposition,
    this.hardiness,
  });

  factory Conditions.fromJson(Map<String, dynamic> json) => Conditions(
        sunlight: json["sunlight"],
        location: json["location"],
        plantingSeason: json["plantingSeason"],
        temperatureRange: json["temperatureRange"],
        soilComposition: json["soilComposition"],
        hardiness: json["hardiness"],
      );
}

class Description {
  final String? item;
  final String? content;

  Description({
    this.item,
    this.content,
  });

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        item: json["item"],
        content: json["content"],
      );
}

class HowTos {
  final String? propagation;
  final String? pruning;
  final String? repotting;
  final String? careTips;

  HowTos({
    this.propagation,
    this.pruning,
    this.repotting,
    this.careTips,
  });

  factory HowTos.fromJson(Map<String, dynamic> json) => HowTos(
        propagation: json["propagation"],
        pruning: json["pruning"],
        repotting: json["repotting"],
        careTips: json["careTips"],
      );
}

class ScientificClassification {
  final String? kingdom;
  final String? phylum;
  final String? classType;
  final String? order;
  final String? family;
  final String? genus;
  final String? species;

  ScientificClassification({
    this.kingdom,
    this.phylum,
    this.classType,
    this.order,
    this.family,
    this.genus,
    this.species,
  });

  factory ScientificClassification.fromJson(Map<String, dynamic> json) => ScientificClassification(
        kingdom: json["kingdom"],
        phylum: json["phylum"],
        classType: json["classType"],
        order: json["order"],
        family: json["family"],
        genus: json["genus"],
        species: json["species"],
      );
}
