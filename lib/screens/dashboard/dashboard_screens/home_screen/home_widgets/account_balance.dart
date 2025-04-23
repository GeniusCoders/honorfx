import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';

class AccountBalance extends StatelessWidget {
  const AccountBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        // Get balance from appropriate state
        String balance = "0.00";
        String currency = "\$";

        if (state is AccountDetailsLoaded) {
          // Format balance to show only 2 decimal places
          try {
            double balanceValue = double.parse(
              state.accountDetails.balance ?? "0.00",
            );
            balance = balanceValue.toStringAsFixed(2);
          } catch (e) {
            balance = "0.00";
          }
          currency = state.accountDetails.currency ?? "\$";
        } else if (state is AccountsLoaded &&
            state.accounts.isNotEmpty &&
            state.selectedAccountIndex != null) {
          // Format balance to show only 2 decimal places
          try {
            double balanceValue = double.parse(
              state.accounts[state.selectedAccountIndex!].balance ?? "0.00",
            );
            balance = balanceValue.toStringAsFixed(2);
          } catch (e) {
            balance = "0.00";
          }
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
      },
    );
  }
}
