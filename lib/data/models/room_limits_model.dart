import 'package:envirosense/domain/entities/room_limits.dart';

class RoomLimitsModel extends RoomLimits {
  RoomLimitsModel({
    required super.id,
    required super.limits,
    super.failedDevices,
  });

  factory RoomLimitsModel.fromJson(Map<String, dynamic> json) {
    Map<String, double> convertLimits(Map<dynamic, dynamic> input) {
      return input.map((key, value) {
        final doubleValue = value is int ? value.toDouble() : value as double;
        return MapEntry(key.toString(), doubleValue);
      });
    }

    return RoomLimitsModel(
      id: json['documentId'],
      limits: convertLimits(json['limits'] as Map),
      failedDevices: json['failedDevices'] != null ? List<String>.from(json['failedDevices'] as List) : null,
    );
  }
}
