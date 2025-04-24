import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:honorfx/cubit/reports_cubit/reports_cubit.dart';
import 'package:honorfx/models/dashboard/reports_model/withdraw_report_model.dart';
import 'package:honorfx/utils/colors.dart';

class WithdrawTransactions extends StatefulWidget {
  const WithdrawTransactions({super.key});

  @override
  State<WithdrawTransactions> createState() => _WithdrawTransactionsState();
}

class _WithdrawTransactionsState extends State<WithdrawTransactions>
    with AutomaticKeepAliveClientMixin {
  List<WithdrawReportData> withdrawReport = [];
  bool _isDataLoaded = false;

  // This keeps the state alive when switching tabs
  @override
  bool get wantKeepAlive => true;

  void _loadData() {
    if (!_isDataLoaded) {
      // Only load if data hasn't been loaded yet
      context.read<ReportsCubit>().getWithdrawReport();
      _isDataLoaded = true;
    }
  }

  @override
  void initState() {
    super.initState();
    // We'll defer loading until the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Must call super.build for AutomaticKeepAliveClientMixin to work
    super.build(context);

    return BlocConsumer<ReportsCubit, ReportsState>(
      listener: (context, state) {
        if (state is WithdrawReportLoaded) {
          withdrawReport = state.withdrawReport;
        }
      },
      builder: (context, state) {
        if (state is ReportsLoading && !_isDataLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ReportsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: AppColors.secondary, size: 40),
                SizedBox(height: 16),
                Text(
                  state.error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ReportsCubit>().getWithdrawReport();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<ReportsCubit>().getWithdrawReport();
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child:
                withdrawReport.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_outlined,
                            color: Colors.grey.shade400,
                            size: 40,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No withdraw transactions found',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: withdrawReport.length,
                      itemBuilder: (context, index) {
                        final transaction = withdrawReport[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: WithdrawTransactionCard(
                            transaction: transaction,
                          ),
                        );
                      },
                    ),
          ),
        );
      },
    );
  }
}

class WithdrawTransactionCard extends StatelessWidget {
  final WithdrawReportData transaction;

  const WithdrawTransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                "assets/icons/withdraw_transaction.svg",
                width: 30.w,
                height: 30.w,
                color: AppColors.secondary,
              ),

              SizedBox(width: 16.w),

              // MT5 ID
              _buildInfoColumn("MT5 ID", transaction.mtaccountid ?? 'N/A'),
              SizedBox(width: 16.w),

              // Payment method (bank account)
              _buildInfoColumn(
                "Payment method",
                transaction.bankaccount ?? 'N/A',
              ),

              SizedBox(width: 16.w),

              // Date
              _buildInfoColumn("Date", transaction.date ?? 'N/A'),

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
                      color: _getStatusColor(transaction.status ?? 'Pending'),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      transaction.status ?? 'Pending',
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
                "\$${transaction.amount ?? '0'}",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
            ],
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
    switch (status.toLowerCase()) {
      case 'approved':
        return AppColors.primary;
      case 'pending':
        return AppColors.secondary;
      case 'hold':
        return Color(0xFF4A4A4A);
      default:
        return Colors.grey;
    }
  }
}

// Keep the TransactionData class for reference
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

// Sample data (keeping for reference)
final List<TransactionData> demoTransactions = [
  TransactionData(
    type: "Deposit",
    id: "123456788",
    date: "Jan 02, 25",
    paymentMethod: "Visa Card",
    mt5Id: "56789865",
    status: "Approved",
    amount: "1000",
  ),
  TransactionData(
    type: "Withdraw",
    id: "123456788",
    date: "Jan 02, 25",
    paymentMethod: "Visa Card",
    mt5Id: "56789865",
    status: "Pending",
    amount: "300",
  ),
  TransactionData(
    type: "Deposit",
    id: "123456788",
    date: "Jan 02, 25",
    paymentMethod: "Visa Card",
    mt5Id: "56789865",
    status: "Approved",
    amount: "100",
  ),
  TransactionData(
    type: "Deposit",
    id: "123456788",
    date: "Jan 02, 25",
    paymentMethod: "Visa Card",
    mt5Id: "56789865",
    status: "Hold",
    amount: "100",
  ),
];
