import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:honorfx/cubit/auth/auth_cubit.dart';
import 'package:honorfx/cubit/auth/auth_state.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/router/app_router.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/gradient_background.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isAuthChecked = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await _localAuth.canCheckBiometrics;
    } on PlatformException {
      canCheckBiometrics = false;
    }

    if (mounted) {
      setState(() {
        _canCheckBiometrics = canCheckBiometrics;
      });
    }
  }

  Future<bool> _authenticate() async {
    if (!_canCheckBiometrics) return true; // Skip if biometrics not available
    if (_isAuthChecked) return true; // Skip if already authenticated

    bool authenticated = false;
    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      setState(() {
        _isAuthChecked = true; // Mark authentication as checked
      });
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable ||
          e.code == auth_error.notEnrolled) {
        // Biometrics not available or not enrolled, skip auth
        setState(() {
          _isAuthChecked = true;
        });
        return true;
      }

      return false;
    }

    return authenticated;
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

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              // Fetch user data when authenticated, no biometric check yet
              context.read<DashboardCubit>().getTokenData();
            } else if (state is AuthUnauthenticated) {
              appRouter.goToLogin();
            }
          },
        ),
        BlocListener<DashboardCubit, DashboardState>(
          listener: (context, state) async {
            if (state is TokenResponseDataState) {
              // Authenticate with biometrics before navigating to dashboard
              bool authenticated = await _authenticate();
              if (authenticated) {
                appRouter.goToDashboard();
              } else {
                // Failed local auth, log out user
                context.read<AuthCubit>().logout();
              }
            }
          },
        ),
      ],
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
