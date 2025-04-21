import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/utils/colors.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isShowLeadingIcon;
  final String? labelText;
  final String? hintText;

  const PasswordTextField({
    Key? key,
    required this.controller,
    this.isShowLeadingIcon = false,
    this.labelText,
    this.hintText,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Enter your password',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
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
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}
