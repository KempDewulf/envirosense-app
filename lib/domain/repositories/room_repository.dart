import 'package:envirosense/domain/entities/room.dart';

abstract class RoomRepository {
  Future<List<Room>> getRooms();
}
