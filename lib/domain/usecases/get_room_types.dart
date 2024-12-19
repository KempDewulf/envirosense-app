import '../repositories/room_type_repository.dart';
import '../entities/RoomType.dart';

class GetRoomTypesUseCase {
  final RoomTypeRepository repository;

  GetRoomTypesUseCase(this.repository);

  Future<List<RoomType>> call() async {
    return await repository.getRoomTypes();
  }
}