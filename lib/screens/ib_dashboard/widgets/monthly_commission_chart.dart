import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/models/ib_program/ib_monthly_commission_response.dart';

class MonthlyCommissionChart extends StatelessWidget {
  final IbMonthlyCommissionData data;

  const MonthlyCommissionChart({Key? key, required this.data})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF17D23).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.attach_money,
                  color: const Color(0xFFF17D23),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Monthly Commission',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 12, height: 12, color: const Color(0xFFF17D23)),
              const SizedBox(width: 8),
              const Text(
                'Commission',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(right: 10),
            height: 240.h,
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(
                  show: true,
                  horizontalInterval: 10,
                  verticalInterval: 10,
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 10,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        );

                        // Convert to int to get the index
                        final index = value.toInt();

                        // Check if the index is valid
                        if (index >= 0 && index < data.date.length) {
                          // Get the date string and format it to show just the day
                          final date = data.date[index];
                          final dayMonth = date.split(' ').take(2).join(' ');

                          return Transform.rotate(
                            angle: -0.4,
                            child: Text(dayMonth, style: style),
                          );
                        }

                        return const SizedBox();
                      },
                      reservedSize: 40,
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.grey[300]!),
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                barGroups: List.generate(
                  data.commission.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data.commission[index],
                        color: const Color(0xFFF17D23),
                        width: 12,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  ),
                ),
                maxY: _getMaxY(),
                minY: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxY() {
    if (data.commission.isEmpty) return 10;
    double max = data.commission.reduce(
      (curr, next) => curr > next ? curr : next,
    );
    // Round up to the next multiple of 10
    return ((max / 10).ceil() * 10).toDouble();
  }
}
