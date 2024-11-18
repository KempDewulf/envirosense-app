import '../../domain/entities/building_statistics.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_data_source.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsDataSource remoteDataSource;

  StatisticsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BuildingStatistics>> getDailyStatistics() async {
    return await remoteDataSource.getDailyStatisticsFromApi();
  }

  @override
  Future<List<BuildingStatistics>> getWeeklyStatistics() async {
    return await remoteDataSource.getWeeklyStatisticsFromApi();
  }

  @override
  Future<List<BuildingStatistics>> getMonthlyStatistics() async {
    return await remoteDataSource.getMonthlyStatisticsFromApi();
  }

  @override
  Future<EnviroScore> getBuildingEnviroScore() async {
    return await remoteDataSource.getBuildingEnviroScoreFromApi();
  }

  @override
  Future<EnviroScore> getRoomEnviroScore(String roomId) async {
    return await remoteDataSource.getRoomEnviroScoreFromApi(roomId);
  }
}
