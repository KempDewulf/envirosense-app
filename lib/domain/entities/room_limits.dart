class RoomLimits {
  final String id;
  final Map<String, double> limits;
  final List<String>? failedDevices;

  const RoomLimits({
    required this.id,
    required this.limits,
    this.failedDevices,
  });

  double? get temperature => limits['temperature'];

  bool get hasFailedDevices => failedDevices?.isNotEmpty ?? false;
}
