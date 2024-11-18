class BuildingStatistics {
  final double enviroScore;
  final DateTime timestamp;
  final Map<String, double> metrics;

  BuildingStatistics({
    required this.enviroScore,
    required this.timestamp,
    required this.metrics,
  });
}

class EnviroScore {
  final String? roomId; // null means building-wide score
  final double score;
  final DateTime timestamp;

  EnviroScore({
    this.roomId,
    required this.score,
    required this.timestamp,
  });
}
