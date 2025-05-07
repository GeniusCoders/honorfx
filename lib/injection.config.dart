// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'cubit/auth/auth_cubit.dart' as _i766;
import 'cubit/dashboard/dashboard_cubit.dart' as _i152;
import 'cubit/ib_dashboard/ib_dashboard_cubit.dart' as _i597;
import 'cubit/login_cubit/login_cubit.dart' as _i536;
import 'cubit/reports_cubit/reports_cubit.dart' as _i332;
import 'cubit/signup/signup_cubit.dart' as _i775;
import 'router/app_router.dart' as _i722;
import 'services/api/dashboard_api.dart' as _i90;
import 'services/api/ib_dashboard_api.dart' as _i270;
import 'services/api/login_api.dart' as _i483;
import 'services/api/signup_api.dart' as _i887;
import 'services/auth_service.dart' as _i706;
import 'services/core/register_module.dart' as _i758;
import 'services/repo/dashboard_repo.dart' as _i942;
import 'services/repo/ib_dashboard_repo.dart' as _i181;
import 'services/repo/login_repo.dart' as _i322;
import 'services/repo/signup_repo.dart' as _i666;
import 'utils/constant/strings.dart' as _i929;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => registerModule.prefs,
    preResolve: true,
  );
  gh.lazySingleton<_i929.Constant>(() => _i929.Constant());
  gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.flutterSecureStorage);
  gh.lazySingleton<_i722.AppRouter>(() => registerModule.appRouter);
  gh.factory<_i706.AuthService>(
      () => _i706.AuthService(gh<_i460.SharedPreferences>()));
  gh.factory<_i766.AuthCubit>(
      () => _i766.AuthCubit(authService: gh<_i706.AuthService>()));
  gh.factory<String>(
    () => registerModule.baseUrl,
    instanceName: 'BaseUrl',
  );
  gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<String>(instanceName: 'BaseUrl')));
  gh.factory<_i942.DashboardRepo>(() => _i90.DashboardApi(
        dio: gh<_i361.Dio>(),
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ));
  gh.factory<_i322.LoginRepo>(() => _i483.LoginApi(
        dio: gh<_i361.Dio>(),
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ));
  gh.factory<_i181.IbDashboardRepo>(() => _i270.IbDashboardApi(
        dio: gh<_i361.Dio>(),
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ));
  gh.factory<_i597.IbDashboardCubit>(() =>
      _i597.IbDashboardCubit(ibDashboardRepo: gh<_i181.IbDashboardRepo>()));
  gh.factory<_i152.DashboardCubit>(
      () => _i152.DashboardCubit(dashboardRepo: gh<_i942.DashboardRepo>()));
  gh.factory<_i332.ReportsCubit>(
      () => _i332.ReportsCubit(dashboardRepo: gh<_i942.DashboardRepo>()));
  gh.factory<_i536.LoginCubit>(
      () => _i536.LoginCubit(loginRepo: gh<_i322.LoginRepo>()));
  gh.factory<_i666.SignupRepo>(() => _i887.SignupApi(dio: gh<_i361.Dio>()));
  gh.factory<_i775.SignupCubit>(
      () => _i775.SignupCubit(signupRepo: gh<_i666.SignupRepo>()));
  return getIt;
}

class _$RegisterModule extends _i758.RegisterModule {}
