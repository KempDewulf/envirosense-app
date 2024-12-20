import 'package:envirosense/data/datasources/room_data_source.dart';
import 'package:envirosense/domain/entities/air_quality.dart';
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
  Future<Room> getRoom(String roomId) async {
    return await remoteDataSource.getRoom(roomId);
  }

  @override
  Future<AirQuality> getAirQuality(String roomId) async {
    return await remoteDataSource.getAirQuality(roomId);
  }

  @override
  Future<void> addRoom(
      String? name, String buildingId, String? roomTypeId) async {
    return await remoteDataSource.addRoom(name, buildingId, roomTypeId);
  }

  @override
  Future<void> addDeviceToRoom(String? roomId, String? deviceId) async {
    return await remoteDataSource.addDeviceToRoom(roomId, deviceId);
  }
}
