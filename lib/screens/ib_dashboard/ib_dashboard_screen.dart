import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_cubit.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_state.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/router/app_router.dart';
import 'package:honorfx/screens/ib_dashboard/widgets/client_transaction_chart.dart';
import 'package:honorfx/screens/ib_dashboard/widgets/monthly_commission_chart.dart';
import 'package:honorfx/screens/ib_dashboard/widgets/top_earnings_table.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';

class IbDashboardScreen extends StatefulWidget {
  const IbDashboardScreen({Key? key}) : super(key: key);

  @override
  State<IbDashboardScreen> createState() => _IbDashboardScreenState();
}

class _IbDashboardScreenState extends State<IbDashboardScreen> {
  final IbDashboardCubit _ibDashboardCubit = getIt<IbDashboardCubit>();
  final AppRouter _appRouter = getIt<AppRouter>();

  @override
  void initState() {
    super.initState();
    _ibDashboardCubit.loadAllIbData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'IB Program'),
      body: BlocBuilder<IbDashboardCubit, IbDashboardState>(
        bloc: _ibDashboardCubit,
        builder: (context, state) {
          if (state is IbDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is IbDashboardError ||
              state is IbMonthlyCommissionError ||
              state is ClientTransactionError ||
              state is TopEarningError) {
            final message = _getErrorMessage(state);
            return Center(child: Text(message));
          } else if (state is IbDashboardCompleteDataLoaded) {
            return _buildCompleteData(state);
          } else if (state is IbDashboardAndMonthlyCommissionLoaded) {
            return _buildDashboardWithMonthlyCommission(state);
          } else if (state is IbDashboardLoaded) {
            return _buildDashboard(state);
          } else if (state is IbMonthlyCommissionLoaded) {
            return _buildMonthlyCommission(state);
          } else if (state is ClientTransactionLoaded) {
            return _buildClientTransaction(state);
          } else if (state is TopEarningLoaded) {
            return _buildTopEarnings(state);
          }
          return const Center(child: Text('No data available'));
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              _appRouter.goToMyClients();
            },
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.people, color: Colors.white),
            label: const Text(
              'My Clients',
              style: TextStyle(color: Colors.white),
            ),
            heroTag: 'myClients',
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            onPressed: () {
              _appRouter.goToTeamWithdrawReport();
            },
            backgroundColor: AppColors.secondary,
            icon: const Icon(Icons.history, color: Colors.white),
            label: const Text(
              'Withdraw Report',
              style: TextStyle(color: Colors.white),
            ),
            heroTag: 'withdrawReport',
          ),
        ],
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

  Widget _buildCompleteData(IbDashboardCompleteDataLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await _ibDashboardCubit.loadAllIbData();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            MonthlyCommissionChart(data: state.monthlyCommissionData),
            const SizedBox(height: 16),
            ClientTransactionChart(data: state.clientTransactionData),
            const SizedBox(height: 16),
            _buildInfoCard(
              '\$${state.dashboardData.withdrawCommission}',
              'Withdraw Commission',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              '\$${state.dashboardData.availableCommission}',
              'Available Commission',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(state.dashboardData.totalVolume, 'Total Volume'),
            const SizedBox(height: 16),
            _buildInfoCard(
              state.dashboardData.totalClients.toString(),
              'Total Clients',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSmallInfoCard(
                    'Active Traders',
                    state.dashboardData.activeTraders.toString(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSmallInfoCard(
                    'Active Sub-IB',
                    state.dashboardData.activeSubIb.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (state.topEarningData != null &&
                state.topEarningData!.isNotEmpty)
              TopEarningsTable(data: state.topEarningData!),
            const SizedBox(height: 80), // Extra space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardWithMonthlyCommission(
    IbDashboardAndMonthlyCommissionLoaded state,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await _ibDashboardCubit.loadAllIbData();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            MonthlyCommissionChart(data: state.monthlyCommissionData),
            const SizedBox(height: 16),
            _buildInfoCard(
              '\$${state.dashboardData.withdrawCommission}',
              'Withdraw Commission',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              '\$${state.dashboardData.availableCommission}',
              'Available Commission',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(state.dashboardData.totalVolume, 'Total Volume'),
            const SizedBox(height: 16),
            _buildInfoCard(
              state.dashboardData.totalClients.toString(),
              'Total Clients',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSmallInfoCard(
                    'Active Traders',
                    state.dashboardData.activeTraders.toString(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSmallInfoCard(
                    'Active Sub-IB',
                    state.dashboardData.activeSubIb.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(IbDashboardLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await _ibDashboardCubit.loadAllIbData();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildInfoCard(
              '\$${state.data.withdrawCommission}',
              'Withdraw Commission',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              '\$${state.data.availableCommission}',
              'Available Commission',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(state.data.totalVolume, 'Total Volume'),
            const SizedBox(height: 16),
            _buildInfoCard(state.data.totalClients.toString(), 'Total Clients'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSmallInfoCard(
                    'Active Traders',
                    state.data.activeTraders.toString(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSmallInfoCard(
                    'Active Sub-IB',
                    state.data.activeSubIb.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyCommission(IbMonthlyCommissionLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await _ibDashboardCubit.loadAllIbData();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(children: [MonthlyCommissionChart(data: state.data)]),
      ),
    );
  }

  Widget _buildClientTransaction(ClientTransactionLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await _ibDashboardCubit.loadAllIbData();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(children: [ClientTransactionChart(data: state.data)]),
      ),
    );
  }

  Widget _buildTopEarnings(TopEarningLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await _ibDashboardCubit.loadAllIbData();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(children: [TopEarningsTable(data: state.data)]),
      ),
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
