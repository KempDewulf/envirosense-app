import 'package:envirosense/domain/entities/room.dart';

abstract class RoomRepository {
  Future<List<Room>> getRooms();
  Future<List<Map<String, dynamic>>> getRoomTypes();
  Future<void> addRoom(Room room);
  Future<void> removeRoom(String roomName);
}
