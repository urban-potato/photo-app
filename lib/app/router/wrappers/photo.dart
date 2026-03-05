import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/photo/index.dart' show PhotoCubit;
import '../../factories/di_container.dart' show di;

@RoutePage(name: 'PhotoFeatureRouteWrapper')
class PhotoFeatureWrapper extends StatelessWidget implements AutoRouteWrapper {
  const PhotoFeatureWrapper({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<PhotoCubit>(
      create: (context) => di<PhotoCubit>()..loadPhotoPaths(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HeroControllerScope(
      controller: HeroController(),
      child: const AutoRouter(),
    );
  }
}
