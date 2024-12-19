class AddDeviceRequest {
  final String? roomId;
  final String? deviceIdentifier;

  AddDeviceRequest(
    this.roomId,
    this.deviceIdentifier,
  );

  Map<String, dynamic> toJson() {
    return {
      'identifier': deviceIdentifier,
      'roomDocumentId': roomId,
    };
  }
}
