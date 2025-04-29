import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/utils/colors.dart';

class AccountList extends StatelessWidget {
  final List<AccountListingTypeData> accounts;
  final int selectedIndex;
  const AccountList({
    super.key,
    required this.accounts,
    required this.selectedIndex,
  });

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
                children: _buildAccountItems(context, state, accounts),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildAccountItems(
    BuildContext context,
    DashboardState state,
    List<AccountListingTypeData> accounts,
  ) {
    if (accounts.isEmpty) return [];

    return accounts.asMap().entries.map((entry) {
      final index = entry.key;
      final account = entry.value;
      final isSelected = index == selectedIndex;

      return AccountListItem(
        accountNumber: "#${account.mtUserid}",
        isSelected: isSelected,
        onTap: () {
          if (!isSelected) {
            context.read<DashboardCubit>().getAccountDetails(
              accountId: account.mtUserid.toString(),
              selectedIndex: index,
            );
          }
        },
      );
    }).toList();
  }
}

class AccountListItem extends StatelessWidget {
  final String accountNumber;
  final bool isSelected;
  final VoidCallback? onTap;

  const AccountListItem({
    super.key,
    required this.accountNumber,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(7),
          border:
              isSelected
                  ? Border.all(color: AppColors.primary, width: 1.5)
                  : null,
        ),
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.only(right: 10.w),
        child: Row(
          children: [
            Text(
              accountNumber,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.black,
              ),
            ),
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
      ),
    );
  }
}
