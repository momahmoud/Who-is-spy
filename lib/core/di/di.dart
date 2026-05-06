import 'package:salfah/core/di/di.config.dart';
// ignore: depend_on_referenced_packages
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt di = GetIt.instance;

@InjectableInit(
  preferRelativeImports: true,
)
void configureDependencies() => di.init();
