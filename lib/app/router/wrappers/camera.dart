import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/photo/index.dart';
import '../../factories/di_container.dart' show di;

@RoutePage(name: 'CameraRoute')
class CameraScreenWrapper extends StatelessWidget {
  const CameraScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraCubit>(
      create: (context) => di<CameraCubit>(),
      child: const CameraScreen(),
    );
  }
}
