import 'dart:developer' show log;
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/router/router.dart' show PictureRoute;
import '../../../provider/index.dart';

@RoutePage()
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          context.router.pushPath('camera');
        },
        child: const Icon(Icons.camera_alt_rounded),
      ),
      body: SafeArea(
        // top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),

          slivers: [
            const SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarColor: Colors.white,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
              pinned: true,
              title: Text('My photos'),
            ),

            BlocConsumer<PhotoCubit, PhotoState>(
              listener: (context, state) {
                if (state is PhotoFailure) {
                  final stateError = state.error;
                  if (stateError == null) return;

                  final message = switch (stateError.type) {
                    PhotoErrorType.load =>
                      'Error loading photos. Please try again',
                    PhotoErrorType.save =>
                      'Error saving photo. Please try again',
                    PhotoErrorType.delete =>
                      'Error deleting photo. Please try again',
                  };

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(message)));
                }
              },
              builder: (context, state) {
                if (state.photoPathsList != null) {
                  if (state.photoPathsList!.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('No photos yet')),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 22.0,
                    ),

                    sliver: _GalleryBody(photoPathsList: state.photoPathsList!),
                  );
                } else if (state is PhotoFailure) {
                  log('Error loading photos: ${state.error.toString()}');
                  return const SliverFillRemaining(
                    child: Center(child: Text('Error loading photos')),
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
      itemCount: photoPathsList.length,
      itemBuilder: (context, index) {
        final imagePath = File(photoPathsList[index]);
        return DecoratedBox(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Hero(
                tag: imagePath.path,
                child: Material(
                  color: Colors.transparent,
                  child: Ink.image(
                    image: FileImage(imagePath),
                    fit: BoxFit.cover,
                    child: InkWell(
                      onTap: () {
                        // TODO: избавиться от импорта роутера из слоя app
                        context.router.push(
                          PictureRoute(picturePath: imagePath.path),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 22);
      },
    );
  }
}
