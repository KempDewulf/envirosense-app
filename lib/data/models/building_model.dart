import 'package:envirosense/domain/entities/building.dart';

class BuildingModel extends Building {
  BuildingModel({
    required super.id,
    required super.name,
    required super.address,
    required super.rooms,
  });

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      id: json['documentId'],
      name: json['name'],
      address: json['address'],
      rooms: json['rooms'],
    );
  }
}
