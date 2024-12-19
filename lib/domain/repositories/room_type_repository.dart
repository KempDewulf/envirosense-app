import 'package:envirosense/domain/entities/roomtype.dart';

abstract class RoomTypeRepository {
  Future<List<RoomType>> getRoomTypes(String buildingId);
}
