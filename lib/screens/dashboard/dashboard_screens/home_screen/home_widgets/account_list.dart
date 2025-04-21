import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:techysquad/utils/colors.dart';

class AccountList extends StatelessWidget {
  const AccountList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Account List",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            AccountListItem(accountNumber: "#12363539"),
            AccountListItem(accountNumber: "#12363539"),
          ],
        ),
      ],
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
