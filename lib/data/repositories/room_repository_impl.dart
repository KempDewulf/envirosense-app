import 'package:envirosense/data/datasources/room_data_source.dart';
import 'package:envirosense/data/models/room_model.dart';

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
  Future<void> addRoom(Room room) async {
    final roomModel = RoomModel(
      id: room.id,
      name: room.name,
      icon: room.icon,
      devices: room.devices,
    );

    await remoteDataSource.addRoom(roomModel);
  }

  @override
  Future<void> removeRoom(String roomName) async {
    await remoteDataSource.removeRoom(roomName);
  }

  @override
  Future<List<Map<String, dynamic>>> getRoomTypes() async {
    return await remoteDataSource.getRoomTypes();
  }
}
