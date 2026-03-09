import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;
import '../../../../shared/presentation/widgets/index.dart' show CustomAppBar;
import '../widgets/index.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.read<ResponsiveSizeCubit>();
    final spacing = responsive.scaleLayout(8);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.screenHPadding,
          ).copyWith(bottom: responsive.screenBPadding),
          child: Column(spacing: spacing, children: [const ThemeSettings()]),
        ),
      ),
    );
  }
}
