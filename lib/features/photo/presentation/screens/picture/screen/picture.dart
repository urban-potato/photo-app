import 'dart:io' show File;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../../../provider/index.dart'
    show PhotoCubit, PhotoDeleteSuccess, PhotoState;

@RoutePage()
class PictureScreen extends StatelessWidget {
  const PictureScreen({super.key, required this.picturePath});

  final String picturePath;

  @override
  Widget build(BuildContext context) {
    final photoCubit = context.read<PhotoCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture'),
        actions: [
          IconButton(
            onPressed: () async {
              await photoCubit.deletePhoto(picturePath);
            },
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocListener<PhotoCubit, PhotoState>(
          listener: (context, state) {
            if (state is PhotoDeleteSuccess && context.mounted) {
              final router = context.router;
              router.popUntil((route) => route.isFirst);
            }
          },

          child: Center(
            child: PhotoView(
              imageProvider: FileImage(File(picturePath)),
              heroAttributes: PhotoViewHeroAttributes(tag: picturePath),
            ),
          ),
        ),
      ),
    );
  }
}
