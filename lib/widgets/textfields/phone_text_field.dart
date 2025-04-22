import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/models/country_model.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/utils/validators.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final CountryModel? selectedCountry;
  final FocusNode? focusNode;

  const PhoneTextField({
    Key? key,
    required this.controller,
    this.selectedCountry,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required';
        }

        if (selectedCountry != null) {
          if (!Validators.isValidPhoneNumber(value, selectedCountry!.code)) {
            return 'Enter a valid phone number';
          }
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: 'Enter your phone number',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
        filled: true,
        fillColor: Colors.white,
        prefixIcon:
            selectedCountry != null
                ? Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 8.w),
                  child: Text(
                    "+${selectedCountry!.phoneCode}",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  ),
                )
                : null,
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
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
    );
  }
}
