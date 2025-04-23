import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:honorfx/controllers/dashboard_controller.dart';

class UserName extends StatelessWidget {
  const UserName({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the controller exists by using Get.put with the tag parameter to
    // avoid creating multiple instances
    final DashboardController dashboardController =
        Get.find<DashboardController>();

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7)),
          child: Image.asset("assets/images/DP.png"),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
            ),
            Obx(
              () => Text(
                dashboardController.userName,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            final ScaffoldState? scaffold = Scaffold.maybeOf(context);
            if (scaffold != null && scaffold.hasDrawer) {
              scaffold.openDrawer();
            }
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Color(0xFFFF5C1E),
            ),
            child: Icon(Icons.menu, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
