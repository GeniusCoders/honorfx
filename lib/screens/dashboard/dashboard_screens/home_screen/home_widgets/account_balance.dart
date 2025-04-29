import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/controllers/dashboard_controller.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';

class AccountBalance extends StatelessWidget {
  final DashboardController dashboardController;
  const AccountBalance({super.key, required this.dashboardController});

  @override
  Widget build(BuildContext context) {
    // Get balance from appropriate state
    String balance = "0.00";
    String currency = "\$";

    if (dashboardController.accountBalanceDetails.value != null) {
      balance = double.parse(
        dashboardController.accountBalanceDetails.value!.balance ?? "0.00",
      ).toStringAsFixed(2);
      currency =
          dashboardController.accountBalanceDetails.value!.currency ?? "\$";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$currency$balance",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp),
        ),
        SizedBox(height: 10.h),
        Text(
          "Account Balance",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
        ),
      ],
    );
  }
}
