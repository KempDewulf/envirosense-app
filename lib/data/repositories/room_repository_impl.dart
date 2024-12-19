import 'package:envirosense/data/datasources/room_data_source.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomDataSource remoteDataSource;

  RoomRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Room>> getRooms() async {
    return await remoteDataSource.getRooms();
  }

  @override
  Future<void> addRoom(
      String? name, String buildingId, String? roomTypeId) async {
    return await remoteDataSource.addRoom(name, buildingId, roomTypeId);
  }

  @override
  Future<void> addDeviceToRoom(String? roomId, String deviceId) async {
    return await remoteDataSource.addDeviceToRoom(roomId, deviceId);
  }
}
