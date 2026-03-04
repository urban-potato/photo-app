import 'dart:io' show File;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../../../provider/index.dart'
    show PhotoCubit, PhotoDeleteSuccess, PhotoState;
import '../widgets/app_bar.dart';

@RoutePage()
class PictureScreen extends StatelessWidget {
  const PictureScreen({super.key, required this.picturePath});

  final String picturePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PictureAppBar(picturePath: picturePath),

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
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
