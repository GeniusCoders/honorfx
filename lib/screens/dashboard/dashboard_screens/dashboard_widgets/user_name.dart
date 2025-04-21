import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/widgets/app_drawer.dart';

class UserName extends StatelessWidget {
  const UserName({super.key});

  @override
  Widget build(BuildContext context) {
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
            Text(
              "Jignesh Patel",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
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
