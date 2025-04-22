import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/utils/colors.dart';

class AccountList extends StatelessWidget {
  const AccountList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account List",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    state is AccountsLoaded
                        ? state.accounts
                            .map(
                              (account) => AccountListItem(
                                accountNumber: account.mtUserid.toString(),
                              ),
                            )
                            .toList()
                        : [],
              ),
            ),
          ],
        );
      },
    );
  }
}

class AccountListItem extends StatelessWidget {
  final String accountNumber;
  const AccountListItem({super.key, required this.accountNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(right: 10.w),
      child: Row(
        children: [
          Text(accountNumber, style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(width: 10.w),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.more_horiz, size: 18.w, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
