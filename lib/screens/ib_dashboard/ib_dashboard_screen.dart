import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_cubit.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_state.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';

class IbDashboardScreen extends StatefulWidget {
  const IbDashboardScreen({Key? key}) : super(key: key);

  @override
  State<IbDashboardScreen> createState() => _IbDashboardScreenState();
}

class _IbDashboardScreenState extends State<IbDashboardScreen> {
  final IbDashboardCubit _ibDashboardCubit = getIt<IbDashboardCubit>();

  @override
  void initState() {
    super.initState();
    _ibDashboardCubit.getIbDashboardData();
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
          } else if (state is IbDashboardError) {
            return Center(child: Text(state.message));
          } else if (state is IbDashboardLoaded) {
            return _buildDashboard(state);
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildDashboard(IbDashboardLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await _ibDashboardCubit.getIbDashboardData();
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
}
