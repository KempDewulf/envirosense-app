import 'package:envirosense/data/models/outside_air_data_model.dart';
import 'package:envirosense/services/outside_air_api_service.dart';

class OutsideAirDataSource {
  final OutsideAirApiService outsideAirApiService;

  OutsideAirDataSource({required this.outsideAirApiService});

  Future<OutsideAirDataModel> getOutsideAir(String city) async {
    try {
      final response = await outsideAirApiService.getRequest(city);
      return OutsideAirDataModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get outside air data');
    }
  }
}
