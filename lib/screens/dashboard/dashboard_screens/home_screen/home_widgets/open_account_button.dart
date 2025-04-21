import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OpenAccountButton extends StatelessWidget {
  const OpenAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Colors.black,
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: Icon(Icons.add_circle, color: Colors.white),
        label: Text(
          "Open New Account",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
