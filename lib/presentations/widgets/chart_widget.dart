import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hyd_smart_app/data/models/data_sensor_model.dart';
// lib/widgets/chart_widget.dart


class ChartWidget extends StatelessWidget {
  final List<DataSensor> dataPoints;

  const ChartWidget({Key? key, required this.dataPoints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = dataPoints.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
            ),
            dotData: FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: true),
      ),
    );
  }
}
