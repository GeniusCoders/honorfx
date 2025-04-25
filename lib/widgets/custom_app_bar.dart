import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double height;
  final List<Widget>? actions;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final Widget? leading;
  const CustomAppBar({
    this.elevation = 0,
    this.bottom,
    this.centerTitle = true,
    this.height = kToolbarHeight,
    required this.title,
    this.actions,
    super.key,
    this.leading,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      leading: leading ?? BackButton(),
      backgroundColor: AppColors.primary,
      centerTitle: centerTitle,
      foregroundColor: AppColors.white,
      scrolledUnderElevation: 0.0,
      title: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          title!,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: .8,
          ),
        ),
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}
