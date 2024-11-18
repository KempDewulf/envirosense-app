import '../repositories/room_repository.dart';

class GetRoomTypesUseCase {
  final RoomRepository repository;

  GetRoomTypesUseCase(this.repository);

  Future<List<Map<String, dynamic>>> call() async {
    return await repository.getRoomTypes();
  }
}
