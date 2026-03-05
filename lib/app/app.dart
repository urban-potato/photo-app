import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart' show TalkerRouteObserver;

import '../shared/presentation/providers/settings/index.dart';
import '../shared/presentation/theme/index.dart' show AppTheme;
import 'app_config.dart';
import 'app_initializer.dart';
import '../shared/presentation/providers/responsive_size/index.dart';

class App extends StatelessWidget {
  const App({super.key, required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return AppInitializer(
      config: config,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return BlocBuilder<ResponsiveSizeCubit, ResponsiveSizeState>(
            builder: (context, responsiveSizeState) {
              final responsive = context.watch<ResponsiveSizeCubit>();

              return MaterialApp.router(
                routerConfig: config.router.config(
                  navigatorObservers: () => [
                    TalkerRouteObserver(config.talker),
                  ],
                ),
                debugShowCheckedModeBanner: false,
                title: 'Photo App',
                theme: AppTheme.light(responsive),
                darkTheme: AppTheme.dark(responsive),
                themeMode: settingsState.settings.themeMode,
              );
            },
          );
        },
      ),
    );
  }
}
