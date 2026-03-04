import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../provider/index.dart' show PhotoCubit;

class PictureAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PictureAppBar({super.key, required this.picturePath});

  final String picturePath;

  @override
  Widget build(BuildContext context) {
    final photoCubit = context.read<PhotoCubit>();

    return AppBar(
      title: const Text('Picture'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          if (context.mounted) {
            final router = context.router;
            router.maybePop();
          }
        },
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await photoCubit.deletePhoto(picturePath);
          },
          icon: const Icon(Icons.delete_rounded),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
