import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../provider/index.dart';

@RoutePage()
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.pushPath('camera');
        },
        child: const Icon(Icons.camera_alt_rounded),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(pinned: true, title: Text('My photos')),

            BlocBuilder<PhotoCubit, PhotoState>(
              builder: (context, state) {
                if (state.photoPathsList != null) {
                  if (state.photoPathsList!.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('No photos yet.')),
                    );
                  }
                  return _GalleryBody(photoPathsList: state.photoPathsList!);
                } else if (state is PhotoFailure) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Error loading photos:\n${state.error.toString()}',
                      ),
                    ),
                  );
                } else {
                  return const SliverFillRemaining(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryBody extends StatelessWidget {
  const _GalleryBody({required this.photoPathsList});

  final List<String> photoPathsList;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemBuilder: (context, index) {
        final imagePath = File(photoPathsList[index]);
        return SizedBox(child: Image.file(imagePath, fit: BoxFit.contain));
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 22);
      },
    );
  }
}
