import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_cubit.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_state.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/screens/ib_dashboard/widgets/withdraw_report_table.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';

class TeamWithdrawReportScreen extends StatefulWidget {
  const TeamWithdrawReportScreen({Key? key}) : super(key: key);

  @override
  State<TeamWithdrawReportScreen> createState() =>
      _TeamWithdrawReportScreenState();
}

class _TeamWithdrawReportScreenState extends State<TeamWithdrawReportScreen> {
  final IbDashboardCubit _ibDashboardCubit = getIt<IbDashboardCubit>();

  @override
  void initState() {
    super.initState();
    _ibDashboardCubit.getIbWithdrawList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Withdraw Report'),
      body: BlocBuilder<IbDashboardCubit, IbDashboardState>(
        bloc: _ibDashboardCubit,
        builder: (context, state) {
          if (state is IbWithdrawListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is IbWithdrawListError) {
            return Center(child: Text(state.message));
          } else if (state is IbWithdrawListLoaded) {
            return _buildContent(state);
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildContent(IbWithdrawListLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await _ibDashboardCubit.getIbWithdrawList();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(children: [WithdrawReportTable(data: state.data)]),
      ),
    );
  }
}
