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
              child: Row(children: _buildAccountItems(context, state)),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildAccountItems(BuildContext context, DashboardState state) {
    final accounts = _getAccountsFromState(state);
    final selectedIndex = _getSelectedIndexFromState(state);

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
            context.read<DashboardCubit>().selectAccount(index);
          }
        },
      );
    }).toList();
  }

  List _getAccountsFromState(DashboardState state) {
    if (state is AccountsLoaded) {
      return state.accounts;
    } else if (state is AccountDetailsLoaded) {
      return state.accounts;
    }
    return [];
  }

  int? _getSelectedIndexFromState(DashboardState state) {
    if (state is AccountsLoaded) {
      return state.selectedAccountIndex;
    } else if (state is AccountDetailsLoaded) {
      return state.selectedAccountIndex;
    }
    return 0;
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
