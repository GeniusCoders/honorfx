import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:honorfx/screens/dashboard/dashboard.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/open_account/open_account_screen.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/support_screen/support_screen.dart';
import 'package:honorfx/screens/ib_dashboard/ib_dashboard_screen.dart';
import 'package:honorfx/screens/login/login_screen.dart';
import 'package:honorfx/screens/signup/signup_screen.dart';
import 'package:honorfx/screens/splash/splash_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/',
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: '/',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => const SignupScreen(),
        ),
        ShellRoute(
          navigatorKey: shellNavigatorKey,
          builder: (context, state, child) => child,
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (context, state) => const Dashboard(),
              routes: [
                GoRoute(
                  path: 'open-account',
                  name: 'open-account',
                  builder: (context, state) => const OpenAccountScreen(),
                ),
                GoRoute(
                  path: 'support',
                  name: 'support',
                  builder: (context, state) => const SupportScreen(),
                ),
                GoRoute(
                  path: 'ib-dashboard',
                  name: 'ib-dashboard',
                  builder: (context, state) => const IbDashboardScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
      errorBuilder:
          (context, state) =>
              Scaffold(body: Center(child: Text('Error: ${state.error}'))),
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

  // Navigate to support screen
  void goToSupport() {
    router.pushNamed('support');
  }

  // Navigate to open account screen
  void goToOpenAccount() {
    router.pushNamed('open-account');
  }

  // Navigate to IB Dashboard screen
  void goToIbDashboard() {
    router.pushNamed('ib-dashboard');
  }
}
