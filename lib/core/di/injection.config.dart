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
import '../../features/beneficiary_registration/data/data_provider/beneficiary_registration_data_provider.dart'
    as _i793;
import '../../features/beneficiary_registration/data/data_provider/beneficiary_registration_data_provider_impl.dart'
    as _i242;
import '../../features/beneficiary_registration/data/repository/beneficiary_registration_repository.dart'
    as _i585;
import '../../features/beneficiary_registration/data/repository/beneficiary_registration_repository_impl.dart'
    as _i744;
import '../../features/causes/bloc/cause_detail_bloc.dart' as _i267;
import '../../features/causes/bloc/causes_list_bloc.dart' as _i398;
import '../../features/causes/data/data_provider/causes_remote_data_provider.dart'
    as _i486;
import '../../features/causes/data/repository/causes_repository.dart' as _i38;
import '../../features/donation/data/data_provider/donation_data_provider.dart'
    as _i495;
import '../../features/donation/data/data_provider/donation_data_provider_impl.dart'
    as _i271;
import '../../features/donation/data/repository/donation_repository.dart'
    as _i488;
import '../../features/donation/data/repository/donation_repository_impl.dart'
    as _i477;
import '../../features/home/bloc/home_bloc.dart' as _i854;
import '../../features/home/data/data_provider/home_remote_data_provider.dart'
    as _i868;
import '../../features/home/data/repository/home_repository.dart' as _i1047;
import '../../features/impact/bloc/impact_bloc.dart' as _i239;
import '../../features/impact/bloc/impact_story_bloc.dart' as _i132;
import '../../features/impact/data/data_provider/impact_remote_data_provider.dart'
    as _i921;
import '../../features/impact/data/repository/impact_repository.dart' as _i825;
import '../../features/profile/bloc/profile_bloc.dart' as _i40;
import '../../features/profile/data/data_provider/profile_data_provider.dart'
    as _i365;
import '../../features/profile/data/data_provider/remote_profile_data_provider.dart'
    as _i196;
import '../../features/profile/data/repository/profile_repository.dart'
    as _i508;
import '../../features/profile/data/repository/profile_repository_impl.dart'
    as _i309;
import '../../features/zakat_calculator/bloc/zakat_calculator_bloc.dart'
    as _i308;
import '../../features/zakat_calculator/data/data_provider/calculator_config_local_data_provider.dart'
    as _i286;
import '../../features/zakat_calculator/data/data_provider/calculator_config_remote_data_provider.dart'
    as _i925;
import '../../features/zakat_calculator/data/repository/calculator_config_repository.dart'
    as _i343;
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
    gh.lazySingleton<_i286.CalculatorConfigLocalDataProvider>(
      () => _i286.CalculatorConfigLocalDataProviderImpl(),
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
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.paymentsDio(gh<_i53.AuthInterceptor>()),
      instanceName: 'paymentsDio',
    );
    gh.lazySingleton<_i723.AuthDataProvider>(
      () => _i379.AuthDataProviderImpl(gh<_i361.Dio>(instanceName: 'authDio')),
    );
    gh.lazySingleton<_i921.ImpactRemoteDataProvider>(
      () => _i921.ImpactRemoteDataProviderImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i583.GoRouter>(
      () => appRouterModule.router(gh<_i543.AuthSessionController>()),
    );
    gh.lazySingleton<_i495.DonationDataProvider>(
      () => _i271.DonationDataProviderImpl(
        gh<_i361.Dio>(instanceName: 'paymentsDio'),
      ),
    );
    gh.lazySingleton<_i868.HomeRemoteDataProvider>(
      () => _i868.HomeRemoteDataProviderImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i488.DonationRepository>(
      () => _i477.DonationRepositoryImpl(gh<_i495.DonationDataProvider>()),
    );
    gh.lazySingleton<_i365.ProfileDataProvider>(
      () => _i196.RemoteProfileDataProvider(
        gh<_i361.Dio>(),
        gh<_i149.AuthTokenStorage>(),
      ),
    );
    gh.lazySingleton<_i925.CalculatorConfigRemoteDataProvider>(
      () => _i925.CalculatorConfigRemoteDataProviderImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i793.BeneficiaryRegistrationDataProvider>(
      () => _i242.BeneficiaryRegistrationDataProviderImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i486.CausesRemoteDataProvider>(
      () => _i486.CausesRemoteDataProviderImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1047.HomeRepository>(
      () => _i1047.HomeRepositoryImpl(gh<_i868.HomeRemoteDataProvider>()),
    );
    gh.lazySingleton<_i825.ImpactRepository>(
      () => _i825.ImpactRepositoryImpl(gh<_i921.ImpactRemoteDataProvider>()),
    );
    gh.lazySingleton<_i104.AuthRepository>(
      () => _i409.AuthRepositoryImpl(
        gh<_i723.AuthDataProvider>(),
        gh<_i149.AuthTokenStorage>(),
        gh<_i543.AuthSessionController>(),
      ),
    );
    gh.lazySingleton<_i38.CausesRepository>(
      () => _i38.CausesRepositoryImpl(gh<_i486.CausesRemoteDataProvider>()),
    );
    gh.lazySingleton<_i343.CalculatorConfigRepository>(
      () => _i343.CalculatorConfigRepositoryImpl(
        gh<_i925.CalculatorConfigRemoteDataProvider>(),
        gh<_i286.CalculatorConfigLocalDataProvider>(),
      ),
    );
    gh.lazySingleton<_i508.ProfileRepository>(
      () => _i309.ProfileRepositoryImpl(gh<_i365.ProfileDataProvider>()),
    );
    gh.factory<_i239.ImpactBloc>(
      () => _i239.ImpactBloc(gh<_i825.ImpactRepository>()),
    );
    gh.factory<_i132.ImpactStoryBloc>(
      () => _i132.ImpactStoryBloc(gh<_i825.ImpactRepository>()),
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
        gh<_i104.AuthRepository>(),
      ),
    );
    gh.factory<_i308.ZakatCalculatorBloc>(
      () => _i308.ZakatCalculatorBloc(gh<_i343.CalculatorConfigRepository>()),
    );
    gh.factory<_i854.HomeBloc>(
      () => _i854.HomeBloc(
        gh<_i1047.HomeRepository>(),
        gh<_i38.CausesRepository>(),
      ),
    );
    gh.factory<_i398.CausesListBloc>(
      () => _i398.CausesListBloc(gh<_i38.CausesRepository>()),
    );
    gh.factory<_i267.CauseDetailBloc>(
      () => _i267.CauseDetailBloc(gh<_i38.CausesRepository>()),
    );
    return this;
  }
}

class _$DioModule extends _i614.DioModule {}

class _$AppRouterModule extends _i800.AppRouterModule {}
