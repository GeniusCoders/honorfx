import 'package:flutter/material.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/router/app_router.dart';

class IbDashboardNavigator {
  static void navigateToIbDashboard(BuildContext context) {
    getIt<AppRouter>().goToIbDashboard();
  }
}
