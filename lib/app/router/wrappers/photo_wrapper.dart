import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesAsync;

import '../../../features/photo/provider/index.dart' show PhotoCubit;
import '../../repositories/photo_repository.dart';

@RoutePage(name: 'PhotoFeatureRouteWrapper')
class PhotoFeatureWrapper extends StatelessWidget implements AutoRouteWrapper {
  const PhotoFeatureWrapper({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    final photoRepository = PhotoRepository(
      preferencesAsync: SharedPreferencesAsync(),
    );

    return BlocProvider<PhotoCubit>(
      create: (context) =>
          PhotoCubit(photoRepository: photoRepository)..loadPhotoPaths(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
