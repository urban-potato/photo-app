import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, RepositoryProvider;
import 'package:talker_flutter/talker_flutter.dart' show Talker;

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
    return RepositoryProvider<Talker>(
      create: (context) => config.talker,
      child: BlocProvider<ResponsiveSizeCubit>(
        create: (context) => di<ResponsiveSizeCubit>(),
        child: child,
      ),
    );
  }
}
