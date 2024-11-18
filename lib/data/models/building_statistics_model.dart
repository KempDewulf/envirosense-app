import '../../domain/entities/building_statistics.dart';

class BuildingStatisticsModel extends BuildingStatistics {
  BuildingStatisticsModel({
    required super.enviroScore,
    required super.timestamp,
    required super.metrics,
  });

  factory BuildingStatisticsModel.fromJson(Map<String, dynamic> json) {
    return BuildingStatisticsModel(
      enviroScore: json['enviroScore'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      metrics: Map<String, double>.from(json['metrics']),
    );
  }
}

class EnviroScoreModel extends EnviroScore {
  EnviroScoreModel({
    super.roomId,
    required super.score,
    required super.timestamp,
  });

  factory EnviroScoreModel.fromJson(Map<String, dynamic> json) {
    return EnviroScoreModel(
      roomId: json['roomId'],
      score: json['score'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
