import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/models/dashboard/account_details_response.dart';
import 'package:honorfx/utils/colors.dart';

class AccountBalanceDetails extends StatelessWidget {
  final AccountDetailsData accountDetails;
  const AccountBalanceDetails({super.key, required this.accountDetails});

  // Helper function to format values to 2 decimal places
  String _formatValue(String? value) {
    if (value == null) return "0.00";
    try {
      double doubleValue = double.parse(value);
      return doubleValue.toStringAsFixed(2);
    } catch (e) {
      return "0.00";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AccountBalanceDetailItem(
          title: "Profit",
          amount:
              "${accountDetails.currency ?? '\$'}${accountDetails.profit?.toStringAsFixed(2) ?? '0.00'}",
          color: AppColors.primary,
        ),
        Container(height: 42.h, width: 1.w, color: Color(0xFFDFDFDF)),
        AccountBalanceDetailItem(
          title: "Equity",
          amount:
              "${accountDetails.currency ?? '\$'}${_formatValue(accountDetails.equity)}",
        ),
        Container(height: 42.h, width: 1.w, color: Color(0xFFDFDFDF)),
        AccountBalanceDetailItem(
          title: "Credit",
          amount:
              "${accountDetails.currency ?? '\$'}${_formatValue(accountDetails.credit)}",
        ),
        Container(height: 42.h, width: 1.w, color: Color(0xFFDFDFDF)),
        AccountBalanceDetailItem(
          title: "Leverage",
          amount: "1:${accountDetails.leverage?.toString() ?? '0'}",
        ),
      ],
    );
  }
}

class AccountBalanceDetailItem extends StatelessWidget {
  final String title;
  final String amount;
  final Color? color;
  const AccountBalanceDetailItem({
    super.key,
    required this.title,
    required this.amount,
    this.color = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          amount,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.lightGrey,
          ),
        ),
      ],
    );
  }
}
