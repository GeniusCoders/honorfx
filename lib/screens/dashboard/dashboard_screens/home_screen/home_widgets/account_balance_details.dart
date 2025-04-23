import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/utils/colors.dart';

class AccountBalanceDetails extends StatelessWidget {
  const AccountBalanceDetails({super.key});

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
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is AccountDetailsLoaded) {
          final details = state.accountDetails;
          final currency = details.currency ?? '\$';

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AccountBalanceDetailItem(
                title: "Profit",
                amount:
                    "$currency${details.profit?.toStringAsFixed(2) ?? '0.00'}",
                color: AppColors.primary,
              ),
              Container(height: 42.h, width: 1.w, color: Color(0xFFDFDFDF)),
              AccountBalanceDetailItem(
                title: "Equity",
                amount: "$currency${_formatValue(details.equity)}",
              ),
              Container(height: 42.h, width: 1.w, color: Color(0xFFDFDFDF)),
              AccountBalanceDetailItem(
                title: "Credit",
                amount: "$currency${_formatValue(details.credit)}",
              ),
              Container(height: 42.h, width: 1.w, color: Color(0xFFDFDFDF)),
              AccountBalanceDetailItem(
                title: "Leverage",
                amount: "1:${details.leverage?.toString() ?? '0'}",
              ),
            ],
          );
        } else if (state is DashboardLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AccountBalanceDetailItem(
                title: "Profit",
                amount: "\$0.00",
                color: AppColors.primary,
              ),
              Container(height: 42.h, width: 1.w, color: Color(0xFFDFDFDF)),
              AccountBalanceDetailItem(title: "Equity", amount: "\$0.00"),
              Container(height: 42.h, width: 1.w, color: Color(0xFFDFDFDF)),
              AccountBalanceDetailItem(title: "Credit", amount: "\$0.00"),
              Container(height: 42.h, width: 1.w, color: Color(0xFFDFDFDF)),
              AccountBalanceDetailItem(title: "Leverage", amount: "1:0"),
            ],
          );
        }
      },
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
