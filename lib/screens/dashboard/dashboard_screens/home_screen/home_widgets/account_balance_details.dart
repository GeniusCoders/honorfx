import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:techysquad/utils/colors.dart';

class AccountBalanceDetails extends StatelessWidget {
  const AccountBalanceDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AccountBalanceDetailItem(
          title: "Unrealized P&L",
          amount: "\$1000",
          color: AppColors.primary,
        ),
        Container(height: 42.h, width: 1.w, color: Color(0xFFDFDFDF)),
        AccountBalanceDetailItem(title: "Equity", amount: "\$400"),
        Container(height: 42.h, width: 1.w, color: Color(0xFFDFDFDF)),
        AccountBalanceDetailItem(title: "Free margin", amount: "\$400"),
        Container(height: 42.h, width: 1.w, color: Color(0xFFDFDFDF)),
        AccountBalanceDetailItem(title: "Actual leverage", amount: "1:2000"),
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
