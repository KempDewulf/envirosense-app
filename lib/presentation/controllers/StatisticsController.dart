import 'package:fl_chart/fl_chart.dart';

import '../../domain/repositories/statistics_repository.dart';
import '../../domain/entities/building_statistics.dart';

class StatisticsController {
  final StatisticsRepository _repository;

  StatisticsController(this._repository);

  Future<List<BuildingStatistics>> getDailyStatistics() async {
    return await _repository.getDailyStatistics();
  }

  Future<List<BuildingStatistics>> getWeeklyStatistics() async {
    return await _repository.getWeeklyStatistics();
  }

  Future<List<BuildingStatistics>> getMonthlyStatistics() async {
    return await _repository.getMonthlyStatistics();
  }

  Future<EnviroScore> getBuildingEnviroScore() async {
    return await _repository.getBuildingEnviroScore();
  }

  Future<EnviroScore> getRoomEnviroScore(String roomId) async {
    return await _repository.getRoomEnviroScore(roomId);
  }

  List<FlSpot> convertToSpots(List<BuildingStatistics> stats) {
    return stats
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.enviroScore))
        .toList();
  }
}
