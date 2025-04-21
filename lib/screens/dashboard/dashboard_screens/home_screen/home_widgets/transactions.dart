import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:honorfx/utils/colors.dart';

class Transactions extends StatelessWidget {
  const Transactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: demoTransactions.length,
        itemBuilder: (context, index) {
          final transaction = demoTransactions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TransactionCard(transaction: transaction),
          );
        },
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionData transaction;

  const TransactionCard({super.key, required this.transaction});

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
              transaction.type == 'Deposit'
                  ? SvgPicture.asset(
                    "assets/icons/deposit_transaction.svg",
                    width: 30.w,
                    height: 30.w,
                    color: AppColors.primary,
                  )
                  : SvgPicture.asset(
                    "assets/icons/withdraw_transaction.svg",
                    width: 30.w,
                    height: 30.w,
                    color: AppColors.secondary,
                  ),

              SizedBox(width: 16.w),

              // Transaction title, id and date
              Padding(
                padding: EdgeInsets.only(right: 26.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.type,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "#${transaction.id}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF8A8A8A),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      transaction.date,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF8A8A8A),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Payment method
              _buildInfoColumn("Payment method", transaction.paymentMethod),

              SizedBox(width: 16.w),

              // MT5 ID
              _buildInfoColumn("MT5 ID", transaction.mt5Id),

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
                      color: _getStatusColor(transaction.status),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      transaction.status,
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

// Sample data
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
