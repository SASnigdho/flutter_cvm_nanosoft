// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_cvm_nanosoft/src/core/database/local_storage.dart'
    as _i419;
import 'package:flutter_cvm_nanosoft/src/core/database/sqf_lite_service.dart'
    as _i585;
import 'package:flutter_cvm_nanosoft/src/core/network/dio_client.dart' as _i735;
import 'package:flutter_cvm_nanosoft/src/features/customer/data/repositories/customer_remote_repository.dart'
    as _i95;
import 'package:flutter_cvm_nanosoft/src/features/customer/data/repositories/customer_repository.dart'
    as _i575;
import 'package:flutter_cvm_nanosoft/src/features/customer/presentation/cubit/add_customer/add_customer_cubit.dart'
    as _i1014;
import 'package:flutter_cvm_nanosoft/src/features/customer/presentation/cubit/customer_detail/customer_detail_cubit.dart'
    as _i918;
import 'package:flutter_cvm_nanosoft/src/features/customer/presentation/cubit/customer_list/customer_list_cubit.dart'
    as _i1031;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i419.LocalStorage>(() => _i419.LocalStorage());
    gh.lazySingleton<_i585.SqfLiteService>(() => _i585.SqfLiteService());
    gh.lazySingleton<_i735.DioClient>(() => _i735.DioClient());
    gh.lazySingleton<_i95.CustomerRemoteRepository>(
      () => _i95.CustomerRemoteRepository(gh<_i735.DioClient>()),
    );
    gh.lazySingleton<_i575.CustomerRepository>(
      () => _i575.CustomerRepository(
        dbHelper: gh<_i585.SqfLiteService>(),
        apiClient: gh<_i95.CustomerRemoteRepository>(),
      ),
    );
    gh.factoryParam<_i918.CustomerDetailCubit, int, dynamic>(
      (customerId, _) =>
          _i918.CustomerDetailCubit(gh<_i575.CustomerRepository>(), customerId),
    );
    gh.factory<_i1014.AddCustomerCubit>(
      () => _i1014.AddCustomerCubit(repository: gh<_i575.CustomerRepository>()),
    );
    gh.factory<_i1031.CustomerListCubit>(
      () =>
          _i1031.CustomerListCubit(repository: gh<_i575.CustomerRepository>()),
    );
    return this;
  }
}
