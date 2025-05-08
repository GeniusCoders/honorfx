import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_cubit.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_state.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/models/ib_program/client_transaction_response.dart';
import 'package:honorfx/models/ib_program/ib_dashboard_response.dart';
import 'package:honorfx/models/ib_program/ib_monthly_commission_response.dart';
import 'package:honorfx/models/ib_program/top_earning_response.dart';
import 'package:honorfx/screens/ib_dashboard/widgets/client_transaction_chart.dart';
import 'package:honorfx/screens/ib_dashboard/widgets/monthly_commission_chart.dart';
import 'package:honorfx/screens/ib_dashboard/widgets/top_earnings_table.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';

class IbDashboardScreen extends StatefulWidget {
  const IbDashboardScreen({Key? key}) : super(key: key);

  @override
  State<IbDashboardScreen> createState() => _IbDashboardScreenState();
}

class _IbDashboardScreenState extends State<IbDashboardScreen> {
  final IbDashboardCubit _ibDashboardCubit = getIt<IbDashboardCubit>();
  IbDashboardData? _dashboardData;
  IbMonthlyCommissionData? _monthlyCommissionData;
  ClientTransactionData? _clientTransactionData;
  List<TopEarningData>? _topEarningData;

  @override
  void initState() {
    super.initState();
    _ibDashboardCubit.loadAllIbData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'IB Program'),
      body: BlocConsumer<IbDashboardCubit, IbDashboardState>(
        bloc: _ibDashboardCubit,
        listener: (context, state) {
          if (state is IbDashboardLoaded) {
            _dashboardData = state.data;
          } else if (state is IbMonthlyCommissionLoaded) {
            _monthlyCommissionData = state.data;
          } else if (state is ClientTransactionLoaded) {
            _clientTransactionData = state.data;
          } else if (state is TopEarningLoaded) {
            _topEarningData = state.data;
          }
        },
        builder: (context, state) {
          if (state is IbDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is IbDashboardError &&
              state is IbMonthlyCommissionError &&
              state is ClientTransactionError &&
              state is TopEarningError) {
            final message = _getErrorMessage(state);
            return Center(child: Text(message));
          }
          return _buildCompleteData();
        },
      ),
    );
  }

  String _getErrorMessage(IbDashboardState state) {
    if (state is IbDashboardError) {
      return state.message;
    } else if (state is IbMonthlyCommissionError) {
      return state.message;
    } else if (state is ClientTransactionError) {
      return state.message;
    } else if (state is TopEarningError) {
      return state.message;
    }
    return 'An error occurred';
  }

  Widget _buildCompleteData() {
    return RefreshIndicator(
      onRefresh: () async {
        await _ibDashboardCubit.loadAllIbData();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (_monthlyCommissionData != null)
              MonthlyCommissionChart(data: _monthlyCommissionData!),
            const SizedBox(height: 16),
            if (_clientTransactionData != null)
              ClientTransactionChart(data: _clientTransactionData!),
            const SizedBox(height: 16),
            if (_dashboardData != null) ...[_buildDashboardData()],
            const SizedBox(height: 16),
            if (_topEarningData != null && _topEarningData!.isNotEmpty)
              TopEarningsTable(data: _topEarningData!),
            const SizedBox(height: 80), // Extra space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardData() {
    return Column(
      children: [
        _buildInfoCard(
          '\$${_dashboardData?.withdrawCommission}',
          'Withdraw Commission',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          '\$${_dashboardData?.availableCommission}',
          'Available Commission',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(_dashboardData?.totalVolume ?? '', 'Total Volume'),
        const SizedBox(height: 16),
        _buildInfoCard(
          _dashboardData?.totalClients.toString() ?? '',
          'Total Clients',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSmallInfoCard(
                'Active Traders',
                _dashboardData?.activeTraders.toString() ?? '',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSmallInfoCard(
                'Active Sub-IB',
                _dashboardData?.activeSubIb.toString() ?? '',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String value, String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

Widget _buildSmallInfoCard(String label, String value) {
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
