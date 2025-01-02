import 'package:envirosense/presentation/controllers/room_controller.dart';

class RoomService {
  final RoomController _roomController;

  RoomService(this._roomController);

  Future<void> renameRoom(String roomId, String newName) async {
    if (roomId.isEmpty) throw Exception('Room id not found');
    await _roomController.updateRoom(roomId, newName);
  }

  Future<void> deleteRoom(String roomId) async {
    if (roomId.isEmpty) throw Exception('Room id not found');
    await _roomController.deleteRoom(roomId);
  }
}
