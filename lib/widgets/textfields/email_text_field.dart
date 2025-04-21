import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/utils/colors.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isShowLeadingIcon;
  final String? labelText;
  final String? hintText;

  const EmailTextField({
    Key? key,
    required this.controller,
    this.isShowLeadingIcon = false,
    this.labelText,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hintText ?? 'Enter your email',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: AppColors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: AppColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: AppColors.grey),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}
