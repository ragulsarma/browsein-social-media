// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:social_media_clone_flutter/src/common/di/firebaseauth_di.dart'
    as _i710;
import 'package:social_media_clone_flutter/src/common/di/firestore_di.dart'
    as _i20;
import 'package:social_media_clone_flutter/src/features/home/domain/persistence/post_dao.dart'
    as _i267;
import 'package:social_media_clone_flutter/src/features/home/presentation/bloc/post_cubit.dart'
    as _i21;
import 'package:social_media_clone_flutter/src/features/login/presentation/bloc/signin_cubit.dart'
    as _i198;
import 'package:social_media_clone_flutter/src/features/uploadPost/presentation/bloc/post_upload_cubit.dart'
    as _i520;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseFireStoreDi = _$FirebaseFireStoreDi();
    final firebaseAuthDi = _$FirebaseAuthDi();
    gh.factory<_i520.PostUploadCubit>(() => _i520.PostUploadCubit());
    gh.factory<_i198.SignInCubit>(() => _i198.SignInCubit());
    gh.lazySingleton<_i267.PostDAO>(() => _i267.PostDAO());
    gh.lazySingleton<_i974.FirebaseFirestore>(
        () => firebaseFireStoreDi.firebaseFireStore);
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseAuthDi.firebaseAuth);
    gh.factory<_i21.PostsCubit>(
        () => _i21.PostsCubit(gh<_i974.FirebaseFirestore>()));
    return this;
  }
}

class _$FirebaseFireStoreDi extends _i20.FirebaseFireStoreDi {}

class _$FirebaseAuthDi extends _i710.FirebaseAuthDi {}
