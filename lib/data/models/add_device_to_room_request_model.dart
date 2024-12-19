class AddDeviceToRoomRequest {
  final String? deviceId;

  AddDeviceToRoomRequest(
    this.deviceId,
  );

  Map<String, dynamic> toJson() {
    return {
      'devices': [deviceId],
    };
  }
}
