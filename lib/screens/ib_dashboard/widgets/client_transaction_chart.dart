import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:honorfx/models/ib_program/client_transaction_response.dart';
import 'package:honorfx/utils/colors.dart';

class ClientTransactionChart extends StatelessWidget {
  final ClientTransactionData data;

  const ClientTransactionChart({Key? key, required this.data})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalDeposit = data.getTotalDeposit();
    final totalWithdraw = data.getTotalWithdraw();

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
                  color: AppColors.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.people, color: AppColors.secondary, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'My Client Transaction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Total Deposit', AppColors.secondary),
              const SizedBox(width: 16),
              _buildLegendItem('Total Withdraw', AppColors.primary),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 70,
                sections: [
                  PieChartSectionData(
                    value: totalDeposit,
                    color: AppColors.secondary,
                    title: '',
                    radius: 60,
                  ),
                  PieChartSectionData(
                    value: totalWithdraw,
                    color: AppColors.primary,
                    title: '',
                    radius: 60,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildValueItem(
                'Deposit',
                '\$${_formatNumber(totalDeposit)}',
                AppColors.secondary,
              ),
              _buildValueItem(
                'Withdraw',
                '\$${_formatNumber(totalWithdraw)}',
                AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildValueItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  String _formatNumber(double number) {
    // Format to 2 decimal places
    return number.toStringAsFixed(2);
  }
}
