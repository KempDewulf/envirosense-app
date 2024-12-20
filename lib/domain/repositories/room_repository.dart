import 'package:envirosense/domain/entities/air_quality.dart';
import 'package:envirosense/domain/entities/room.dart';

abstract class RoomRepository {
  Future<List<Room>> getRooms();
  Future<Room> getRoom(String roomId);
  Future<AirQuality> getAirQuality(String roomId);
  Future<void> addRoom(String? name, String buildingId, String? roomTypeId);
  Future<void> addDeviceToRoom(String? roomId, String? deviceId);
}
