import 'package:flutter/material.dart';
import 'package:hyd_smart_app/core/constans/colors.dart';

Color colorIndicator({String? ph, String? tds}) {
  double? sensorPh = ph != null && ph.isNotEmpty ? double.tryParse(ph) : null;
  double? sensorTds =
      tds != null && tds.isNotEmpty ? double.tryParse(tds) : null;

  if (sensorPh != null) {
    if (sensorPh >= 0.0 && sensorPh <= 4.0) {
      return AppColors.red;
    } else if (sensorPh > 4.0 && sensorPh <= 7.0) {
      return AppColors.primary;
    } else if (sensorPh > 7.0 && sensorPh <= 14.0) {
      return AppColors.yellow;
    }
  }

  if (sensorTds != null) {
    if (sensorTds < 500) {
      return AppColors.blue;
    } else if (sensorTds >= 500 && sensorTds <= 1200) {
      return AppColors.primary;
    } else {
      return AppColors.yellow;
    }
  }

  return AppColors.gray;
}
