class AddRoomRequest {
  final String? name;
  final String buildingId;
  final String? roomTypeId;

  AddRoomRequest(
    this.name,
    this.buildingId,
    this.roomTypeId,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'buildingDocumentId': buildingId,
      'roomTypeDocumentId': roomTypeId,
    };
  }
}
