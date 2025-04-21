import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:honorfx/screens/login/login_screen.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/utils/comman_texfield.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/widgets/gradient_background.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _agreeToTerms = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/techysquad_logo.png',
                    height: 60.h,
                  ),
                ),
                SizedBox(height: 40.h),
                // Welcome text
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Sign up to get started',
                  style: TextStyle(fontSize: 14.sp, color: AppColors.lightGrey),
                ),
                SizedBox(height: 30.h),

                // Full Name input
                _buildInputLabel('Full Name'),
                SizedBox(height: 8.h),
                const CommanTexfield(hintText: 'Enter your full name'),
                SizedBox(height: 16.h),

                // Email/Phone input
                _buildInputLabel('Email'),
                SizedBox(height: 8.h),
                const CommanTexfield(hintText: 'Enter your email'),
                SizedBox(height: 16.h),

                // Country input
                _buildInputLabel('Country'),
                SizedBox(height: 8.h),
                CommonDropdown(
                  hintText: 'Select your country',
                  onChanged: (value) {},
                ),
                SizedBox(height: 16.h),

                // Phone input
                _buildInputLabel('Phone'),
                SizedBox(height: 8.h),
                const CommanTexfield(hintText: 'Enter your phone number'),
                SizedBox(height: 16.h),

                // Password input
                _buildInputLabel('Password'),
                SizedBox(height: 8.h),
                _buildPasswordField(
                  isVisible: _isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  hintText: 'Create password',
                ),
                SizedBox(height: 16.h),

                // Confirm Password input
                _buildInputLabel('Referral Code'),
                SizedBox(height: 8.h),
                const CommanTexfield(hintText: 'Enter your referral code'),
                SizedBox(height: 20.h),

                // Terms and conditions checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value!;
                          });
                        },
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            const TextSpan(
                              text: 'By creating an account, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),

                // Signup Button
                _buildSignupButton(),
                SizedBox(height: 30.h),

                // Already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildPasswordField({
    required bool isVisible,
    required Function onToggleVisibility,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: AppColors.grey),
      ),
      child: TextField(
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey,
            ),
            onPressed: () => onToggleVisibility(),
          ),
        ),
      ),
    );
  }

  Widget _buildSignupButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sign Up',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8.w),
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: SvgPicture.asset(
                'assets/icons/arrow-circle-right.svg',
                width: 20.w,
                height: 20.h,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
