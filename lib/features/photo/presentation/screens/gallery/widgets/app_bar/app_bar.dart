import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../shared/presentation/providers/index.dart'
    show NavigationProviderI, SettingsAppRoute;

class GalleryAppBar extends StatelessWidget {
  const GalleryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      title: const Text('Photos'),
      actions: [
        IconButton(
          onPressed: () {
            if (context.mounted) {
              final router = context.read<NavigationProviderI>();
              router.push(context, const SettingsAppRoute());
            }
          },
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }
}
