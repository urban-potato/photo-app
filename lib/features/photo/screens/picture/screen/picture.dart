import 'dart:io' show File;

import 'package:auto_route/auto_route.dart' show RoutePage;
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

@RoutePage()
class PictureScreen extends StatelessWidget {
  const PictureScreen({super.key, required this.picturePath});

  final String picturePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture')),
      body: SafeArea(
        child: Center(
          child: PhotoView(
            imageProvider: FileImage(File(picturePath)),
            heroAttributes: PhotoViewHeroAttributes(tag: picturePath),
          ),
        ),
      ),
    );
  }
}
