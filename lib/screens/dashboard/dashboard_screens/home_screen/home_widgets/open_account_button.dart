import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/router/app_router.dart';
import 'package:honorfx/utils/colors.dart';

class OpenAccountButton extends StatelessWidget {
  const OpenAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: AppColors.primary,
      ),
      child: TextButton.icon(
        onPressed: () {
          // getIt<AppRouter>().goToOpenAccount();
          getIt<AppRouter>().goToIbDashboard();
        },
        icon: Icon(Icons.add_circle, color: Colors.white),
        label: Text(
          "Open New Account",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
