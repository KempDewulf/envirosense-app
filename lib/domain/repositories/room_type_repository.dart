import 'package:envirosense/domain/entities/room_type.dart';

abstract class RoomTypeRepository {
  Future<List<RoomType>> getRoomTypes(String buildingId);
}
