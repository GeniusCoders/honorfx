import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:honorfx/screens/dashboard/dashboard.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/open_account/open_account_screen.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/support_screen/support_screen.dart';
import 'package:honorfx/screens/ib_dashboard/ib_dashboard_screen.dart';
import 'package:honorfx/screens/ib_dashboard/ib_withdraw_screen.dart';
import 'package:honorfx/screens/ib_dashboard/my_clients_screen.dart';
import 'package:honorfx/screens/ib_dashboard/my_commission_screen.dart';
import 'package:honorfx/screens/ib_dashboard/request_ib_screen.dart';
import 'package:honorfx/screens/ib_dashboard/team_withdraw_report_screen.dart';
import 'package:honorfx/screens/login/forgot_password/forgot_password.dart';
import 'package:honorfx/screens/login/login_screen.dart';
import 'package:honorfx/screens/signup/signup_screen.dart';
import 'package:honorfx/screens/splash/splash_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

final GlobalKey<NavigatorState> authNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'auth',
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
        ShellRoute(
          navigatorKey: authNavigatorKey,
          builder: (context, state, child) => child,
          routes: [
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
            GoRoute(
              path: '/forgot-password',
              name: 'forgot-password',
              builder: (context, state) => const ForgotPasswordScreen(),
            ),
          ],
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
                GoRoute(
                  path: 'team-withdraw-report',
                  name: 'team-withdraw-report',
                  builder: (context, state) => const TeamWithdrawReportScreen(),
                ),
                GoRoute(
                  path: 'my-clients',
                  name: 'my-clients',
                  builder: (context, state) => const MyClientsScreen(),
                ),
                GoRoute(
                  path: 'my-commission',
                  name: 'my-commission',
                  builder: (context, state) => const MyCommissionScreen(),
                ),
                GoRoute(
                  path: 'ib-withdraw',
                  name: 'ib-withdraw',
                  builder: (context, state) => const IbWithdrawScreen(),
                ),
                GoRoute(
                  path: 'request-ib',
                  name: 'request-ib',
                  builder: (context, state) => const RequestIbScreen(),
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

  // Navigate to forgot password screen
  void goToForgotPassword() {
    router.goNamed('forgot-password');
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

  // Navigate to Team Withdraw Report screen
  void goToTeamWithdrawReport() {
    router.pushNamed('team-withdraw-report');
  }

  // Navigate to My Clients screen
  void goToMyClients() {
    router.pushNamed('my-clients');
  }

  // Navigate to My Commission screen
  void goToMyCommission() {
    router.pushNamed('my-commission');
  }

  // Navigate to IB Withdraw screen
  void goToIbWithdraw() {
    router.pushNamed('ib-withdraw');
  }

  // Navigate to Request IB screen
  void goToRequestIb() {
    router.pushNamed('request-ib');
  }
}
