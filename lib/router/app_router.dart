import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:honorfx/screens/dashboard/dashboard.dart';
import 'package:honorfx/screens/login/login_screen.dart';
import 'package:honorfx/screens/signup/signup_screen.dart';
import 'package:honorfx/screens/splash/splash_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const Dashboard(),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => const SignupScreen(),
        ),
      ],
    );
  }

  // Navigate to login screen and clear history
  void goToLogin() {
    router.goNamed('login');
  }

  // Navigate to dashboard screen and clear history
  void goToDashboard() {
    router.goNamed('dashboard');
  }

  // Navigate to signup screen
  void goToSignup() {
    router.goNamed('signup');
  }
}
