import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:honorfx/controllers/dashboard_controller.dart';
import 'package:honorfx/cubit/auth/auth_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/login_cubit.dart';
import 'package:honorfx/cubit/signup/signup_cubit.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/router/app_router.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/utils/constant/strings.dart';

// Binding class to initialize controllers
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  // Initialize GetX bindings
  InitialBinding().dependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<LoginCubit>()),
            BlocProvider(create: (context) => getIt<SignupCubit>()),
            BlocProvider(create: (context) => getIt<DashboardCubit>()),
            BlocProvider(create: (context) => getIt<AuthCubit>()),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: Constant.appName,
            theme: ThemeData(
              fontFamily: 'Manrope',
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              useMaterial3: true,
            ),
            routerConfig: appRouter.router,
          ),
        );
      },
    );
  }
}
