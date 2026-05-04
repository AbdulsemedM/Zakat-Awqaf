// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;

import '../../app/router/app_router_module.dart' as _i800;
import '../../features/awqaf/bloc/awqaf_bloc.dart' as _i833;
import '../network/dio_module.dart' as _i614;
import '../network_info/network_info.dart' as _i845;
import '../network_info/network_info_impl.dart' as _i137;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appRouterModule = _$AppRouterModule();
    final dioModule = _$DioModule();
    gh.factory<_i833.AwqafBloc>(() => _i833.AwqafBloc());
    gh.lazySingleton<_i583.GoRouter>(() => appRouterModule.router());
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i845.NetworkInfo>(() => _i137.NetworkInfoImpl());
    return this;
  }
}

class _$AppRouterModule extends _i800.AppRouterModule {}

class _$DioModule extends _i614.DioModule {}
