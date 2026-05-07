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
import '../../features/impact/bloc/impact_bloc.dart' as _i239;
import '../../features/impact/data/data_provider/impact_data_provider.dart'
    as _i141;
import '../../features/impact/data/data_provider/mock_impact_data_provider.dart'
    as _i600;
import '../../features/impact/data/repository/impact_repository.dart' as _i825;
import '../../features/impact/data/repository/impact_repository_impl.dart'
    as _i994;
import '../../features/profile/bloc/profile_bloc.dart' as _i40;
import '../../features/profile/data/data_provider/mock_profile_data_provider.dart'
    as _i599;
import '../../features/profile/data/data_provider/profile_data_provider.dart'
    as _i365;
import '../../features/profile/data/repository/profile_repository.dart'
    as _i508;
import '../../features/profile/data/repository/profile_repository_impl.dart'
    as _i309;
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
    gh.lazySingleton<_i583.GoRouter>(() => appRouterModule.router());
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i845.NetworkInfo>(() => _i137.NetworkInfoImpl());
    gh.lazySingleton<_i141.ImpactDataProvider>(
      () => _i600.MockImpactDataProvider(),
    );
    gh.lazySingleton<_i825.ImpactRepository>(
      () => _i994.ImpactRepositoryImpl(gh<_i141.ImpactDataProvider>()),
    );
    gh.lazySingleton<_i365.ProfileDataProvider>(
      () => _i599.MockProfileDataProvider(),
    );
    gh.lazySingleton<_i508.ProfileRepository>(
      () => _i309.ProfileRepositoryImpl(gh<_i365.ProfileDataProvider>()),
    );
    gh.factory<_i239.ImpactBloc>(
      () => _i239.ImpactBloc(gh<_i825.ImpactRepository>()),
    );
    gh.factory<_i40.ProfileBloc>(
      () => _i40.ProfileBloc(gh<_i508.ProfileRepository>()),
    );
    return this;
  }
}

class _$AppRouterModule extends _i800.AppRouterModule {}

class _$DioModule extends _i614.DioModule {}
