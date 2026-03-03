import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiMode, SystemChrome;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart' show TalkerRouteObserver;

import 'app_config.dart';
import 'app_initializer.dart';
import '../shared/presentation/providers/responsive_size/index.dart';
import 'theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key, required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return AppInitializer(
      config: config,
      child: BlocBuilder<ResponsiveSizeCubit, ResponsiveSizeState>(
        builder: (context, state) {
          final responsive = context.watch<ResponsiveSizeCubit>();

          return MaterialApp.router(
            routerConfig: config.router.config(
              navigatorObservers: () => [TalkerRouteObserver(config.talker)],
            ),
            debugShowCheckedModeBanner: false,
            title: 'Photo App',
            theme: TAppTheme.lightTheme(responsive),
          );
        },
      ),
    );
  }
}
