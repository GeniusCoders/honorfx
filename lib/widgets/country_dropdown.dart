import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/models/country_model.dart';
import 'package:honorfx/utils/colors.dart';

class CountryDropdown extends StatelessWidget {
  final List<CountryModel> countries;
  final CountryModel? selectedCountry;
  final Function(CountryModel?) onChanged;
  final String hintText;
  final String? Function(CountryModel?)? validator;

  const CountryDropdown({
    Key? key,
    required this.countries,
    this.selectedCountry,
    required this.onChanged,
    required this.hintText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CountryModel>(
      decoration: InputDecoration(
        hintText: hintText,
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
      value: selectedCountry,
      items:
          countries.map((country) {
            return DropdownMenuItem<CountryModel>(
              value: country,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(country.flag, style: TextStyle(fontSize: 18.sp)),
                  SizedBox(width: 8.w),
                  Text(country.name),
                  SizedBox(width: 8.w),
                  Text(
                    "(+${country.phoneCode})",
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                ],
              ),
            );
          }).toList(),
      onChanged: onChanged,
      validator: validator,
      icon: Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
      isExpanded: true,
      dropdownColor: Colors.white,
    );
  }
}
