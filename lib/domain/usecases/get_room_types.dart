import 'package:envirosense/domain/entities/roomtype.dart';
import 'package:envirosense/domain/repositories/room_type_repository.dart';

class GetRoomTypesUseCase {
  final RoomTypeRepository repository;

  GetRoomTypesUseCase(this.repository);

  Future<List<RoomType>> call(String buildingId) async {
    return await repository.getRoomTypes(buildingId);
  }
}