import '../entities/building_statistics.dart';

abstract class StatisticsRepository {
  Future<List<BuildingStatistics>> getDailyStatistics();
  Future<List<BuildingStatistics>> getWeeklyStatistics();
  Future<List<BuildingStatistics>> getMonthlyStatistics();
  Future<EnviroScore> getBuildingEnviroScore();
  Future<EnviroScore> getRoomEnviroScore(String roomId);
}
