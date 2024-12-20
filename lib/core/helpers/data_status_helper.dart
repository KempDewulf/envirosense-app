import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum Status {
  good,
  medium,
  bad,
}

class Thresholds {
  static const temperature = (
    min: 18.0,
    max: 35.0,
    optimalMin: 20.0,
    optimalMax: 24.0,
  );

  static const humidity = (
    min: 30.0,
    max: 70.0,
    optimalMin: 40.0,
    optimalMax: 60.0,
  );

  static const airQuality = (
    max: 1000,
    optimalMax: 800,
  );
}

class DataStatusHelper {
  static Status getTemperatureStatus(double temp) {
    return _getStatus(
      temp,
      min: Thresholds.temperature.min,
      max: Thresholds.temperature.max,
      optimalMin: Thresholds.temperature.optimalMin,
      optimalMax: Thresholds.temperature.optimalMax,
    );
  }

  static Status getHumidityStatus(double humidity) {
    return _getStatus(
      humidity,
      min: Thresholds.humidity.min,
      max: Thresholds.humidity.max,
      optimalMin: Thresholds.humidity.optimalMin,
      optimalMax: Thresholds.humidity.optimalMax,
    );
  }

  static Status getAirQualityStatus(int ppm) {
    if (ppm > Thresholds.airQuality.max) return Status.bad;
    if (ppm > Thresholds.airQuality.optimalMax) return Status.medium;
    return Status.good;
  }

  static Color getStatusColor(Status status) {
    switch (status) {
      case Status.good:
        return AppColors.greenColor;
      case Status.medium:
        return AppColors.secondaryColor;
      case Status.bad:
        return AppColors.redColor;
    }
  }

  static Status _getStatus(
    num value, {
    required num min,
    required num max,
    required num optimalMin,
    required num optimalMax,
  }) {
    if (value < min || value > max) return Status.bad;
    if (value < optimalMin || value > optimalMax) return Status.medium;
    return Status.good;
  }
}
