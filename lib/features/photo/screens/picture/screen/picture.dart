import 'dart:io' show File;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../../../provider/index.dart' show PhotoCubit;

@RoutePage()
class PictureScreen extends StatelessWidget {
  const PictureScreen({super.key, required this.picturePath});

  final String picturePath;

  @override
  Widget build(BuildContext context) {
    final photoCubit = context.read<PhotoCubit>();
    final router = context.router;
    // final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture'),
        actions: [
          IconButton(
            onPressed: () async {
              final isSuccess = await photoCubit.deletePhotoPath(picturePath);
              if (isSuccess) {
                router.pop();
              } else {
                // messenger.showSnackBar(
                //   const SnackBar(content: Text('Error deleting picture')),
                // );
              }
            },
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: PhotoView(
            imageProvider: FileImage(File(picturePath)),
            heroAttributes: PhotoViewHeroAttributes(tag: picturePath),
          ),
        ),
      ),
    );
  }
}
