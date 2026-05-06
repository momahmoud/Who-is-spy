// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../infrastructure/local_data_base/base_local_data_base.dart' as _i405;
import '../infrastructure/local_data_base/hive_local_data_base.dart' as _i393;
import '../infrastructure/network/api_consumer.dart' as _i865;
import '../infrastructure/network/app_interceptor.dart' as _i356;
import '../infrastructure/network/dio_consumer.dart' as _i774;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i356.AppInterceptors>(() => _i356.AppInterceptors());
    gh.lazySingleton<_i405.BaseDatabase>(() => _i393.HiveDatabaseClient());
    gh.lazySingleton<_i865.ApiConsumer>(
      () => _i774.DioConsumer(client: gh<_i361.Dio>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
