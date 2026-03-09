import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../../../shared/presentation/providers/index.dart'
    show NavigationProviderI;
import '../../../../../../shared/presentation/widgets/index.dart'
    show CustomAppBar;
import '../../../provider/index.dart'
    show PhotoCubit, PhotoDeleteSuccess, PhotoState;

class PictureScreen extends StatelessWidget {
  const PictureScreen({super.key, required this.picturePath});

  final String picturePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Picture',
        actions: [
          IconButton(
            onPressed: () async {
              if (context.mounted) {
                final photoCubit = context.read<PhotoCubit>();
                await photoCubit.deletePhoto(picturePath);
              }
            },
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),

      body: SafeArea(
        child: BlocListener<PhotoCubit, PhotoState>(
          listener: (context, state) {
            if (state is PhotoDeleteSuccess && context.mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (context.mounted) {
                  final photoCubit = context.read<PhotoCubit>();
                  final router = context.read<NavigationProviderI>();

                  photoCubit.loadPhotoPaths();
                  router.popToFirst(context);
                }
              });
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
