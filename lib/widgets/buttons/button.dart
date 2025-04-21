import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const Button({
    Key? key,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: fontSize ?? 16.sp,
            fontWeight: fontWeight ?? FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
