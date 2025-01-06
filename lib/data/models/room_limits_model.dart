import 'package:envirosense/domain/entities/room_limits.dart';

class RoomLimitsModel extends RoomLimits {
  RoomLimitsModel({
    required super.id,
    required super.limits,
    super.failedDevices,
  });

  factory RoomLimitsModel.fromJson(Map<String, dynamic> json) {
    return RoomLimitsModel(
      id: json['documentId'],
      limits: json['limits'],
      failedDevices: json['failedDevices'],
    );
  }
}
