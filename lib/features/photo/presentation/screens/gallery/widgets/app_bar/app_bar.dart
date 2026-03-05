import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../../../app/router/router.dart' show SettingsRoute;

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
              final router = context.router;
              router.push(const SettingsRoute());
            }
          },
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }
}
