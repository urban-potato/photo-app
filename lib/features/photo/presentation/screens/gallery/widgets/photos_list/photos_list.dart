import 'dart:io' show File;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../app/router/router.dart' show PictureRoute;
import '../../../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;
import 'utils/grid_config_helper.dart';

class PhotosList extends StatelessWidget {
  const PhotosList({super.key, required this.photoPathsList});

  final List<String> photoPathsList;

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
        final imageFile = File(photoPathsList[index]);

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
                    context.router.push(
                      PictureRoute(picturePath: imageFile.path),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }, childCount: photoPathsList.length),
    );
  }
}
