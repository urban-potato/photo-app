import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show
        BlocProvider,
        RepositoryProvider,
        MultiBlocProvider,
        MultiRepositoryProvider;
import 'package:talker_flutter/talker_flutter.dart' show Talker;

import '../shared/presentation/providers/index.dart' show NavigationProviderI;
import '../shared/presentation/providers/settings/index.dart'
    show SettingsCubit;
import 'app_config.dart';
import 'factories/di_container.dart' show di;
import '../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key, required this.child, required this.config});

  final Widget child;
  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Talker>(create: (context) => di<Talker>()),
        RepositoryProvider<NavigationProviderI>(
          create: (context) => di<NavigationProviderI>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ResponsiveSizeCubit>(
            create: (context) => di<ResponsiveSizeCubit>(),
          ),
          BlocProvider<SettingsCubit>(create: (context) => di<SettingsCubit>()),
        ],
        child: child,
      ),
    );
  }
}
