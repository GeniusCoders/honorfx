import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountBalance extends StatelessWidget {
  const AccountBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "\$1000",
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
