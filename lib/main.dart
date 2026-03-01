import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc;
import 'package:talker_bloc_logger/talker_bloc_logger.dart'
    show TalkerBlocObserver, TalkerBlocLoggerSettings;
import 'package:talker_flutter/talker_flutter.dart';

import 'app/app.dart';
import 'app/app_config.dart';
import 'app/factories/di_container.dart' show initializeDependencies;
import 'app/router/router.dart' show AppRouter;

void main() {
  final router = AppRouter();
  final talker = TalkerFlutter.init();
  final appConfig = AppConfig(talker: talker, router: router);

  talker.verbose('App started');

  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: const TalkerBlocLoggerSettings(
      printChanges: true,
      printEventFullData: false,
      printStateFullData: false,
      printCreations: true,
      printClosings: true,
    ),
  );

  initializeDependencies(config: appConfig);

  runApp(App(config: appConfig));
}
