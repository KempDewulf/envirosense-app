import 'package:envirosense/domain/entities/outside_air_data.dart';

class OutsideAirDataModel extends OutsideAirData {
  OutsideAirDataModel({
    required super.temperature,
    required super.humidity,
  });

  factory OutsideAirDataModel.fromJson(Map<String, dynamic> json) {
    return OutsideAirDataModel(
      temperature: json['current']['temp_c'] is String ? double.parse(json['current']['temp_c']) : (json['current']['temp_c'] as num).toDouble(),
      humidity: json['current']['humidity'] is String ? double.parse(json['current']['humidity']) : (json['current']['humidity'] as num).toDouble(),
    );
  }
}
