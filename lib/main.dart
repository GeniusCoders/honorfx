import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/auth/auth_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/login_cubit.dart';
import 'package:honorfx/cubit/signup/signup_cubit.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/screens/splash/splash_screen.dart';
import 'package:honorfx/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HonorFX',
            theme: ThemeData(
              fontFamily: 'Manrope',
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
