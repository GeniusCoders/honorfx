import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:techysquad/utils/colors.dart';

class CommonDropdown extends StatelessWidget {
  final String hintText;
  final Function(String?) onChanged;
  const CommonDropdown({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: AppColors.grey),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            hintText,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down),
          items: null,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
