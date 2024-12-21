class UpdateRoomRequest {
  final String? name;

  UpdateRoomRequest(
    this.name,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}