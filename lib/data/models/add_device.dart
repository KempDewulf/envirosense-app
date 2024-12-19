class AddDeviceRequest {
  final String? roomId;
  final String? deviceIdentifier;

  AddDeviceRequest(
    this.roomId,
    this.deviceIdentifier,
  );

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'identifier': deviceIdentifier,
    };
  }
}
