import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:honorfx/cubit/reports_cubit/reports_cubit.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/models/dashboard/reports_model/deposit_report_model.dart';
import 'package:honorfx/utils/extensions/date_extension.dart';
import 'package:honorfx/widgets/shimmer/shimmer.dart';

class DepositTransactions extends StatefulWidget {
  const DepositTransactions({super.key});

  @override
  State<DepositTransactions> createState() => _DepositTransactionsState();
}

class _DepositTransactionsState extends State<DepositTransactions> {
  List<DepositReportData> depositReport = [];

  @override
  void initState() {
    super.initState();
    context.read<ReportsCubit>().getDepositReport();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportsCubit, ReportsState>(
      listener: (context, state) {
        if (state is DepositReportLoaded) {
          depositReport = state.depositReport;
        }
      },
      builder: (context, state) {
        if (state is ReportsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: depositReport.length,
            itemBuilder: (context, index) {
              final transaction = depositReport[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TransactionCard(transaction: transaction),
              );
            },
          ),
        );
      },
    );
  }
}

class TransactionCard extends StatelessWidget {
  final DepositReportData transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Transaction icon
                SvgPicture.asset(
                  "assets/icons/deposit_transaction.svg",
                  width: 30.w,
                  height: 30.w,
                  color: AppColors.primary,
                ),

                SizedBox(width: 16.w),

                // MT5 ID
                _buildInfoColumn("MT5 ID", transaction.mtaccountid ?? ""),

                SizedBox(width: 16.w),

                // Payment method
                _buildInfoColumn(
                  "Payment method",
                  transaction.paymentmethod ?? "",
                ),

                SizedBox(width: 16.w),

                _buildInfoColumn(
                  "Date",
                  transaction.date != null
                      ? transaction.date!.toFormattedDateTime()
                      : "",
                ),

                SizedBox(width: 16.w),

                // Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF8A8A8A),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(transaction.status ?? ""),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        transaction.status ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 16.w),

                // Amount
                Text(
                  "\$${transaction.amount}",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Color(0xFF8A8A8A),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return AppColors.primary;
      case 'Pending':
        return AppColors.secondary;
      case 'Hold':
        return Color(0xFF4A4A4A);
      default:
        return Colors.grey;
    }
  }
}

// Model class for transaction data
class TransactionData {
  final String type;
  final String id;
  final String date;
  final String paymentMethod;
  final String mt5Id;
  final String status;
  final String amount;

  TransactionData({
    required this.type,
    required this.id,
    required this.date,
    required this.paymentMethod,
    required this.mt5Id,
    required this.status,
    required this.amount,
  });
}
