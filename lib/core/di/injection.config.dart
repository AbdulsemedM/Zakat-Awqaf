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
import '../../features/awqaf/presentation/bloc/awqaf_bloc.dart' as _i856;
import '../../features/zakat/data/datasources/local/zakat_local_datasource.dart'
    as _i726;
import '../../features/zakat/data/datasources/local/zakat_local_datasource_impl.dart'
    as _i752;
import '../../features/zakat/data/datasources/remote/zakat_remote_datasource.dart'
    as _i636;
import '../../features/zakat/data/datasources/remote/zakat_remote_datasource_impl.dart'
    as _i433;
import '../../features/zakat/data/repositories/zakat_repository_impl.dart'
    as _i365;
import '../../features/zakat/domain/repositories/zakat_repository.dart'
    as _i767;
import '../../features/zakat/presentation/bloc/zakat_bloc.dart' as _i167;
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
    gh.factory<_i856.AwqafBloc>(() => _i856.AwqafBloc());
    gh.lazySingleton<_i583.GoRouter>(() => appRouterModule.router());
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i845.NetworkInfo>(() => _i137.NetworkInfoImpl());
    gh.lazySingleton<_i726.ZakatLocalDataSource>(
      () => _i752.ZakatLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i636.ZakatRemoteDataSource>(
      () => _i433.ZakatRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i767.ZakatRepository>(
      () => _i365.ZakatRepositoryImpl(gh<_i636.ZakatRemoteDataSource>()),
    );
    gh.factory<_i167.ZakatBloc>(
      () => _i167.ZakatBloc(gh<_i767.ZakatRepository>()),
    );
    return this;
  }
}

class _$AppRouterModule extends _i800.AppRouterModule {}

class _$DioModule extends _i614.DioModule {}
