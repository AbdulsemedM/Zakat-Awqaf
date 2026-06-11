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
import '../../features/auth/bloc/auth_bloc.dart' as _i55;
import '../../features/auth/data/data_provider/auth_data_provider.dart'
    as _i723;
import '../../features/auth/data/data_provider/auth_data_provider_impl.dart'
    as _i379;
import '../../features/auth/data/repository/auth_repository.dart' as _i104;
import '../../features/auth/data/repository/auth_repository_impl.dart' as _i409;
import '../../features/beneficiary_registration/bloc/beneficiary_registration_bloc.dart'
    as _i424;
import '../../features/beneficiary_registration/data/beneficiary_sse_client.dart'
    as _i848;
import '../../features/beneficiary_registration/data/data_provider/beneficiary_registration_data_provider.dart'
    as _i793;
import '../../features/beneficiary_registration/data/data_provider/beneficiary_registration_data_provider_impl.dart'
    as _i242;
import '../../features/beneficiary_registration/data/repository/beneficiary_registration_repository.dart'
    as _i585;
import '../../features/beneficiary_registration/data/repository/beneficiary_registration_repository_impl.dart'
    as _i744;
import '../../features/impact/bloc/impact_bloc.dart' as _i239;
import '../../features/impact/data/data_provider/impact_data_provider.dart'
    as _i141;
import '../../features/impact/data/data_provider/mock_impact_data_provider.dart'
    as _i600;
import '../../features/impact/data/repository/impact_repository.dart' as _i825;
import '../../features/impact/data/repository/impact_repository_impl.dart'
    as _i994;
import '../../features/profile/bloc/profile_bloc.dart' as _i40;
import '../../features/profile/data/data_provider/profile_data_provider.dart'
    as _i365;
import '../../features/profile/data/data_provider/remote_profile_data_provider.dart'
    as _i196;
import '../../features/profile/data/repository/profile_repository.dart'
    as _i508;
import '../../features/profile/data/repository/profile_repository_impl.dart'
    as _i309;
import '../auth/auth_interceptor.dart' as _i53;
import '../auth/auth_session_controller.dart' as _i543;
import '../auth/auth_token_storage.dart' as _i149;
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
    final dioModule = _$DioModule();
    final appRouterModule = _$AppRouterModule();
    gh.lazySingleton<_i149.AuthTokenStorage>(() => _i149.AuthTokenStorage());
    gh.lazySingleton<_i845.NetworkInfo>(() => _i137.NetworkInfoImpl());
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.authDio(),
      instanceName: 'authDio',
    );
    gh.lazySingleton<_i543.AuthSessionController>(
      () => _i543.AuthSessionController(gh<_i149.AuthTokenStorage>()),
    );
    gh.lazySingleton<_i141.ImpactDataProvider>(
      () => _i600.MockImpactDataProvider(),
    );
    gh.lazySingleton<_i825.ImpactRepository>(
      () => _i994.ImpactRepositoryImpl(gh<_i141.ImpactDataProvider>()),
    );
    gh.lazySingleton<_i53.AuthInterceptor>(
      () => _i53.AuthInterceptor(
        gh<_i149.AuthTokenStorage>(),
        gh<_i543.AuthSessionController>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.dio(gh<_i53.AuthInterceptor>()),
    );
    gh.lazySingleton<_i723.AuthDataProvider>(
      () => _i379.AuthDataProviderImpl(gh<_i361.Dio>(instanceName: 'authDio')),
    );
    gh.factory<_i239.ImpactBloc>(
      () => _i239.ImpactBloc(gh<_i825.ImpactRepository>()),
    );
    gh.lazySingleton<_i583.GoRouter>(
      () => appRouterModule.router(gh<_i543.AuthSessionController>()),
    );
    gh.lazySingleton<_i365.ProfileDataProvider>(
      () => _i196.RemoteProfileDataProvider(
        gh<_i361.Dio>(),
        gh<_i149.AuthTokenStorage>(),
      ),
    );
    gh.lazySingleton<_i848.BeneficiarySseClient>(
      () => _i848.BeneficiarySseClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i793.BeneficiaryRegistrationDataProvider>(
      () => _i242.BeneficiaryRegistrationDataProviderImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i104.AuthRepository>(
      () => _i409.AuthRepositoryImpl(
        gh<_i723.AuthDataProvider>(),
        gh<_i149.AuthTokenStorage>(),
        gh<_i543.AuthSessionController>(),
      ),
    );
    gh.lazySingleton<_i508.ProfileRepository>(
      () => _i309.ProfileRepositoryImpl(gh<_i365.ProfileDataProvider>()),
    );
    gh.factory<_i55.AuthBloc>(() => _i55.AuthBloc(gh<_i104.AuthRepository>()));
    gh.factory<_i40.ProfileBloc>(
      () => _i40.ProfileBloc(
        gh<_i508.ProfileRepository>(),
        gh<_i104.AuthRepository>(),
      ),
    );
    gh.lazySingleton<_i585.BeneficiaryRegistrationRepository>(
      () => _i744.BeneficiaryRegistrationRepositoryImpl(
        gh<_i793.BeneficiaryRegistrationDataProvider>(),
      ),
    );
    gh.factory<_i424.BeneficiaryRegistrationBloc>(
      () => _i424.BeneficiaryRegistrationBloc(
        gh<_i585.BeneficiaryRegistrationRepository>(),
        gh<_i848.BeneficiarySseClient>(),
        gh<_i104.AuthRepository>(),
      ),
    );
    return this;
  }
}

class _$DioModule extends _i614.DioModule {}

class _$AppRouterModule extends _i800.AppRouterModule {}
