import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiMode, SystemChrome;
import 'package:flutter_bloc/flutter_bloc.dart' show RepositoryProvider;
import 'package:talker_flutter/talker_flutter.dart'
    show Talker, TalkerRouteObserver;

import 'app_config.dart';
import 'theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key, required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return RepositoryProvider<Talker>(
      create: (context) => config.talker,
      child: MaterialApp.router(
        routerConfig: config.router.config(
          navigatorObservers: () => [TalkerRouteObserver(config.talker)],
        ),
        debugShowCheckedModeBanner: false,
        title: 'Photo App',
        theme: TAppTheme.lightTheme(),
      ),
    );
  }
}
