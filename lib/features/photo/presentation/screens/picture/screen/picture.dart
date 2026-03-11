import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../../../shared/presentation/providers/index.dart'
    show NavigationProviderI;
import '../../../../../../shared/presentation/widgets/index.dart'
    show CustomAppBar;
import '../../../provider/index.dart'
    show
        PhotoCubit,
        PhotoDeleteSuccess,
        PhotoState,
        PhotoFailure,
        PhotoErrorTypeMessage;

class PictureScreen extends StatefulWidget {
  const PictureScreen({super.key, required this.picturePath});

  final String picturePath;

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                final paths = photoCubit.state.photoPathsList ?? [];
                if (paths.isNotEmpty) {
                  await photoCubit.deletePhoto(paths[_currentIndex]);
                }
              }
            },
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),

      body: SafeArea(
        child: BlocConsumer<PhotoCubit, PhotoState>(
          listener: (context, state) {
            if (state is PhotoDeleteSuccess && context.mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (context.mounted) {
                  final photoCubit = context.read<PhotoCubit>();
                  await photoCubit.loadPhotoPaths();

                  final paths = photoCubit.state.photoPathsList ?? [];
                  if (paths.isEmpty) {
                    if (context.mounted) {
                      final router = context.read<NavigationProviderI>();
                      router.popToFirst(context);
                    }
                  } else {
                    _currentIndex = _currentIndex.clamp(0, paths.length - 1);
                    _pageController.animateToPage(
                      _currentIndex,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                }
              });
            } else if (state is PhotoFailure && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.error?.type.message ?? 'Error deleting photo',
                  ),
                ),
              );
            }
          },

          builder: (context, state) {
            final paths = state.photoPathsList ?? [];

            if (paths.isEmpty) {
              return const Center(child: Text('No photos yet'));
            }

            if (_currentIndex == 0 && paths.contains(widget.picturePath)) {
              _currentIndex = paths.indexOf(widget.picturePath);
              _pageController = PageController(initialPage: _currentIndex);
            }

            if (_currentIndex > 0) {
              precacheImage(FileImage(File(paths[_currentIndex - 1])), context);
            }
            if (_currentIndex < paths.length - 1) {
              precacheImage(FileImage(File(paths[_currentIndex + 1])), context);
            }

            return PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemCount: paths.length,
              itemBuilder: (context, index) {
                final path = paths[index];

                return Center(
                  child: PhotoView(
                    imageProvider: FileImage(File(path)),
                    heroAttributes: PhotoViewHeroAttributes(tag: path),
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
