import 'package:envirosense/data/datasources/room_data_source.dart';
import 'package:envirosense/data/repositories/room_repository_impl.dart';
import 'package:envirosense/domain/entities/room.dart';
import '../../domain/usecases/get_rooms.dart';

class RoomController {
  final GetRoomsUseCase getRoomsUseCase;

  RoomController(): getRoomsUseCase = GetRoomsUseCase(
    RoomRepositoryImpl(
      remoteDataSource: RoomDataSource(),
    ),
  );

  Future<List<Room>> fetchRooms() async {
    return await getRoomsUseCase();
  }
}
