import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_clone_flutter/src/common/di/di.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
GetIt getItInit() => getIt.init();
