import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;
import '../../../../../shared/presentation/providers/settings/index.dart';

class ThemeSettings extends StatelessWidget {
  const ThemeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final responsive = context.read<ResponsiveSizeCubit>();
        final spacing = responsive.scaleLayout(8);

        return Column(
          spacing: spacing,
          mainAxisSize: MainAxisSize.min,
          children: [const _ThemeTitle(), const _ThemeSegmentedButton()],
        );
      },
    );
  }
}

class _ThemeSegmentedButton extends StatelessWidget {
  const _ThemeSegmentedButton();

  @override
  Widget build(BuildContext context) {
    final responsive = context.read<ResponsiveSizeCubit>();
    final settings = context.read<SettingsCubit>();
    final theme = Theme.of(context);

    final borderRadius = responsive.radiusS;
    final fontSizeButtons = responsive.textS;

    List<ButtonSegment<ThemeMode>> segments(double fontSize) => [
      ButtonSegment(
        value: ThemeMode.system,
        label: Text('System', style: TextStyle(fontSize: fontSize)),
      ),
      ButtonSegment(
        value: ThemeMode.light,
        label: Text('Light', style: TextStyle(fontSize: fontSize)),
      ),
      ButtonSegment(
        value: ThemeMode.dark,
        label: Text('Dark', style: TextStyle(fontSize: fontSize)),
      ),
    ];

    ButtonStyle style(ThemeData theme, double radius) {
      return ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        ),
        side: const WidgetStatePropertyAll(BorderSide.none),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return theme.colorScheme.inversePrimary;
          }
          return theme.colorScheme.surfaceContainerHighest;
        }),
        foregroundColor: WidgetStatePropertyAll(theme.colorScheme.onSurface),
      );
    }

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: SegmentedButton<ThemeMode>(
            segments: segments(fontSizeButtons),
            selected: {state.settings.themeMode},
            onSelectionChanged: (Set<ThemeMode> newSelection) async {
              await settings.setThemeMode(newSelection.first);
            },
            showSelectedIcon: false,

            style: style(theme, borderRadius),
          ),
        );
      },
    );
  }
}

class _ThemeTitle extends StatelessWidget {
  const _ThemeTitle();

  @override
  Widget build(BuildContext context) {
    final responsive = context.read<ResponsiveSizeCubit>();
    final fontSizeTitle = responsive.textM;

    return Text(
      'Theme',
      style: TextStyle(fontSize: fontSizeTitle, fontWeight: FontWeight.w600),
    );
  }
}
