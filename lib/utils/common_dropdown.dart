import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/utils/colors.dart';

class CommonDropdown extends StatelessWidget {
  final String hintText;
  final Function(String?) onChanged;
  final List<String> data;
  final String? value;
  const CommonDropdown({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.data,
    this.value,
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
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(border: InputBorder.none),
          hint: Text(
            hintText,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
          ),
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down),
          items:
              data.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
