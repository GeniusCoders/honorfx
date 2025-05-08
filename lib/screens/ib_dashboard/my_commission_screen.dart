import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_cubit.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_state.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/screens/ib_dashboard/widgets/my_commission_table.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

class MyCommissionScreen extends StatefulWidget {
  const MyCommissionScreen({Key? key}) : super(key: key);

  @override
  State<MyCommissionScreen> createState() => _MyCommissionScreenState();
}

class _MyCommissionScreenState extends State<MyCommissionScreen> {
  final IbDashboardCubit _ibDashboardCubit = getIt<IbDashboardCubit>();

  // Default date range (1 month ago to current date)
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();

  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _ibDashboardCubit.getMyCommission(
      _dateFormat.format(_fromDate),
      _dateFormat.format(_toDate),
    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2020),
      lastDate: _toDate,
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
      _fetchData();
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: _fromDate,
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
      });
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Commission'),
      body: BlocBuilder<IbDashboardCubit, IbDashboardState>(
        bloc: _ibDashboardCubit,
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              _fetchData();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildDateSelectors(),
                  SizedBox(height: 16.h),
                  if (state is MyCommissionLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (state is MyCommissionError)
                    Center(child: Text(state.message))
                  else if (state is MyCommissionLoaded)
                    MyCommissionTable(data: state.data)
                  else
                    const Center(child: Text('No data available')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateSelectors() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _buildDateField(
                label: 'From:',
                date: _fromDate,
                onTap: () => _selectFromDate(context),
              ),
              SizedBox(width: 12.w),
              _buildDateField(
                label: 'To:',
                date: _toDate,
                onTap: () => _selectToDate(context),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _fetchData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _dateFormat.format(date),
                    style: TextStyle(fontSize: 13.sp),
                  ),
                  Icon(Icons.calendar_today, size: 16.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
