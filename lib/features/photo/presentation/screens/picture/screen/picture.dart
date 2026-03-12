import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:photo_view/photo_view.dart';

import '../../../../../../shared/presentation/providers/index.dart'
    show NavigationProviderI;
import '../../../../../../shared/presentation/widgets/index.dart'
    show CustomAppBar;
import '../../../models/index.dart' show PhotoItemModelUI;
import '../../../provider/index.dart';
import '../widgets/index.dart';

class PictureScreen extends StatefulWidget {
  const PictureScreen({super.key, required this.initialPhoto});

  final PhotoItemModelUI initialPhoto;

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    final photos = context.read<PhotoCubit>().state.photos?.photosList ?? [];

    _currentIndex = photos.indexOf(widget.initialPhoto);
    if (_currentIndex == -1) _currentIndex = 0;

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  ({String date, String time}) _getFormattedDateAndTime(DateTime dateTime) {
    final date = DateFormat('MMMM d, y').format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return (date: date, time: time);
  }

  @override
  Widget build(BuildContext context) {
    final photoCubit = context.read<PhotoCubit>();
    final photos = photoCubit.state.photos?.photosList ?? [];

    final title = 'Picture';
    Widget? titleWidget;
    void Function()? onPressed;

    if (photos.isNotEmpty) {
      final photo = photos[_currentIndex];
      final (:date, :time) = _getFormattedDateAndTime(photo.dateTime);

      titleWidget = TitleWidget(date: date, time: time);
      onPressed = () async {
        await photoCubit.deletePhoto(photos[_currentIndex].path);
      };
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        titleWidget: titleWidget,
        actions: [
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),

      body: SafeArea(
        child: BlocConsumer<PhotoCubit, PhotoState>(
          listener: (context, state) {
            if (state is PhotoLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (context.mounted) {
                  final photos = state.photos?.photosList ?? [];
                  if (photos.isEmpty) {
                    final router = context.read<NavigationProviderI>();
                    router.popToFirst(context);
                  } else {
                    _currentIndex = _currentIndex.clamp(0, photos.length - 1);

                    if (_currentIndex > 0) {
                      precacheImage(
                        FileImage(File(photos[_currentIndex - 1].path)),
                        context,
                      );
                    }
                    if (_currentIndex < photos.length - 1) {
                      precacheImage(
                        FileImage(File(photos[_currentIndex + 1].path)),
                        context,
                      );
                    }

                    if (_pageController.hasClients) {
                      _pageController.animateToPage(
                        _currentIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
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
            final photos = state.photos?.photosList ?? [];

            if (photos.isNotEmpty) {
              return PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final path = photos[index].path;

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
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
