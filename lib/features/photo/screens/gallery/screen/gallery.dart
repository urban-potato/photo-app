import 'dart:developer' show log;
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        top: false,
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

            BlocBuilder<PhotoCubit, PhotoState>(
              builder: (context, state) {
                if (state.photoPathsList != null) {
                  if (state.photoPathsList!.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('No photos yet.')),
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
        print(MediaQuery.of(context).size.width);
        return DecoratedBox(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.file(imagePath, fit: BoxFit.cover),
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
