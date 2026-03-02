import 'dart:io' show File;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/router/router.dart' show PictureRoute;
import '../../../../../../shared/presentation/providers/responsive_size/index.dart';

class PhotosList extends StatelessWidget {
  const PhotosList({super.key, required this.photoPathsList});

  final List<String> photoPathsList;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: photoPathsList.length,
      itemBuilder: (context, index) {
        final router = context.router;
        final imagePath = File(photoPathsList[index]);

        final responsiveSizeCubit = context.watch<ResponsiveSizeCubit>();
        final tileHeight = responsiveSizeCubit.scaleLayout(190);
        final borderRadius = responsiveSizeCubit.radiusL;

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: SizedBox(
            height: tileHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Hero(
                tag: imagePath.path,
                child: Material(
                  color: Colors.transparent,
                  child: Ink.image(
                    image: FileImage(imagePath),
                    fit: BoxFit.cover,
                    child: InkWell(
                      onTap: () {
                        router.push(PictureRoute(picturePath: imagePath.path));
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
        final responsiveSizeCubit = context.watch<ResponsiveSizeCubit>();
        final sepatarotHeight = responsiveSizeCubit.scaleLayout(15);

        return SizedBox(height: sepatarotHeight);
      },
    );
  }
}
