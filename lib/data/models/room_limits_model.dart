import 'package:envirosense/domain/entities/room_limits.dart';

class RoomLimitsModel extends RoomLimits {
  RoomLimitsModel({
    required super.id,
    required super.limits,
    super.failedDevices,
  });

  factory RoomLimitsModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      return RoomLimitsModel(
        id: '',
        limits: {},
        failedDevices: [''],
      );
    }

    return RoomLimitsModel(
      id: json['documentId'],
      limits: Map<String, double>.from(json['limits'] as Map),
      failedDevices: json['failedDevices'] != null
          ? List<String>.from(json['failedDevices'] as List)
          : null,
    );
  }
}
