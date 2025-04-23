import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:honorfx/cubit/login_cubit.dart';
import 'package:honorfx/screens/dashboard/dashboard.dart';
import 'package:honorfx/screens/signup/signup_screen.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/gradient_background.dart';
import 'package:honorfx/widgets/loading/loading.dart';
import 'package:honorfx/widgets/snackbar/snackbars.dart';
import 'package:honorfx/widgets/textfields/email_text_field.dart';
import 'package:honorfx/widgets/textfields/password_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void _onLogin() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
            (route) => false,
          );
        } else if (state is LoginFailed) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBars.errorSnackBar(title: state.error));
        }
      },
      builder: (BuildContext context, LoginState state) {
        return Stack(
          children: [
            GradientBackground(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                extendBody: true,
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40.h),
                          // Logo
                          Center(
                            child: SvgPicture.asset(
                              'assets/images/honorfx_logo.svg',
                              height: 60.h,
                            ),
                          ),
                          SizedBox(height: 60.h),
                          // Welcome text
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Sign in to continue',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.lightGrey,
                            ),
                          ),
                          SizedBox(height: 40.h),

                          // Email/Phone input
                          _buildInputLabel('Email / Phone Number'),
                          SizedBox(height: 8.h),
                          EmailTextField(controller: _emailController),
                          SizedBox(height: 20.h),

                          // Password input
                          _buildInputLabel('Password'),
                          SizedBox(height: 8.h),
                          PasswordTextField(
                            controller: _passwordController,
                            isShowLeadingIcon: true,
                            labelText: "Enter your Password",
                          ),
                          SizedBox(height: 16.h),

                          // Remember me and Forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Remember me checkbox
                              Row(
                                children: [
                                  SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value!;
                                        });
                                      },
                                      activeColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Remember me',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              // Forgot password button
                              TextButton(
                                onPressed: () {
                                  // TODO: Implement forgot password navigation
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40.h),

                          // Login Button
                          _buildLoginButton(),
                          SizedBox(height: 30.h),

                          // Don't have an account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account? ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const SignupScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (state is LoginLoading) const Loading(),
          ],
        );
      },
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onLogin,
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
              'Login',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8.w),
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: SvgPicture.asset(
                'assets/icons/arrow-circle-right.svg',
                width: 18.w,
                height: 18.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
