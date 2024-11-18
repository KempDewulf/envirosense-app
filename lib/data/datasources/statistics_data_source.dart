import 'package:envirosense/data/models/building_statistics_model.dart';

class StatisticsDataSource {
  Future<List<BuildingStatisticsModel>> getDailyStatisticsFromApi() async {
    // TODO: Implement API call
    return [];
  }

  Future<List<BuildingStatisticsModel>> getWeeklyStatisticsFromApi() async {
    // TODO: Implement API call
    return [];
  }

  Future<List<BuildingStatisticsModel>> getMonthlyStatisticsFromApi() async {
    // TODO: Implement API call
    return [];
  }

  Future<EnviroScoreModel> getBuildingEnviroScoreFromApi() async {
    // TODO: Implement API call
    return EnviroScoreModel(
      score: 85.0,
      timestamp: DateTime.now(),
    );
  }

  Future<EnviroScoreModel> getRoomEnviroScoreFromApi(String roomId) async {
    // TODO: Implement API call
    return EnviroScoreModel(
      roomId: roomId,
      score: 85.0,
      timestamp: DateTime.now(),
    );
  }
}
