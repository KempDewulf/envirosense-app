import 'package:envirosense/domain/entities/room.dart';

abstract class RoomRepository {
  Future<List<Room>> getRooms();
  Future<void> addRoom(name, buildingId, roomTypeId);
}
