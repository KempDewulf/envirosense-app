import 'package:envirosense/data/datasources/room_data_source.dart';
import 'package:envirosense/domain/entities/room_air_quality.dart';
import 'package:envirosense/domain/entities/room_limits.dart';
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
  Future<RoomAirQuality> getRoomAirQuality(String roomId) async {
    return await remoteDataSource.getRoomAirQuality(roomId);
  }

  @override
  Future<RoomLimits> getRoomLimits(String roomId) async {
    return await remoteDataSource.getRoomLimits(roomId);
  }

  @override
  Future<void> addRoom(String? name, String buildingId, String? roomTypeId) async {
    return await remoteDataSource.addRoom(name, buildingId, roomTypeId);
  }

  @override
  Future<void> deleteRoom(String? roomId) async {
    return await remoteDataSource.deleteRoom(roomId);
  }

  @override
  Future<void> updateRoom(String? roomId, String? name) async {
    return await remoteDataSource.updateRoom(roomId, name);
  }

  @override
  Future<void> addDeviceToRoom(String? roomId, String? deviceId) async {
    return await remoteDataSource.addDeviceToRoom(roomId, deviceId);
  }

  @override
  Future<void> removeDeviceFromRoom(String? roomId, String? deviceId) async {
    return await remoteDataSource.removeDeviceFromRoom(roomId, deviceId);
  }
}
