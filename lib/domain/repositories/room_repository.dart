import 'package:envirosense/domain/entities/room_air_quality.dart';
import 'package:envirosense/domain/entities/room_limits.dart';
import 'package:envirosense/domain/entities/room.dart';

abstract class RoomRepository {
  Future<List<Room>> getRooms();
  Future<Room> getRoom(String roomId);
  Future<RoomAirQuality> getRoomAirQuality(String roomId);
  Future<RoomLimits> getRoomLimits(String roomId);
  Future<void> addRoom(String? name, String buildingId, String? roomTypeId);
  Future<void> deleteRoom(String? roomId);
  Future<void> updateRoom(String? roomId, String? name);
  Future<void> addDeviceToRoom(String? roomId, String? deviceId);
  Future<void> removeDeviceFromRoom(String? roomId, String? deviceId);
}
