import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;
import '../../../../../../../shared/presentation/providers/index.dart'
    show NavigationProviderI, PictureAppRoute;
import '../../../../models/index.dart' show PhotoItemModelUI;
import 'utils/grid_config_helper.dart';

class PhotosList extends StatelessWidget {
  const PhotosList({super.key, required this.photos});

  final List<PhotoItemModelUI> photos;

  @override
  Widget build(BuildContext context) {
    final responsive = context.watch<ResponsiveSizeCubit>();

    final spacing = responsive.scaleLayout(8);
    final borderRadius = responsive.radiusS;

    final config = PhotosGridConfig.get(
      isPortrait: responsive.state.isVertical,
      isTablet: responsive.isTablet,
    );

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: config.crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: config.childAspectRatio,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final photo = photos[index];
        final imageFile = File(photo.path);

        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Hero(
            tag: imageFile.path,
            child: Material(
              color: Colors.transparent,
              child: Ink.image(
                image: FileImage(imageFile),
                fit: BoxFit.cover,
                child: InkWell(
                  onTap: () {
                    if (context.mounted) {
                      final router = context.read<NavigationProviderI>();
                      router.push(
                        context,
                        PictureAppRoute(initialPhoto: photo),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        );
      }, childCount: photos.length),
    );
  }
}
