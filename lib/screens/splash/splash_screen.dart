import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:honorfx/cubit/auth/auth_cubit.dart';
import 'package:honorfx/cubit/auth/auth_state.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/router/app_router.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/gradient_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Delay for showing the splash screen
    await Future.delayed(const Duration(milliseconds: 600));

    // Check auth status using the AuthCubit
    if (mounted) {
      context.read<AuthCubit>().checkAuthStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          appRouter.goToDashboard();
        } else if (state is AuthUnauthenticated) {
          appRouter.goToLogin();
        }
      },
      child: GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                SvgPicture.asset(
                  'assets/images/honorfx_logo.svg',
                  height: 80.h,
                ),
                SizedBox(height: 30.h),
                // Loading indicator
                CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
