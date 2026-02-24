import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
            SliverList.separated(
              itemBuilder: (context, index) {
                return SizedBox(
                  child: Image.network(
                    'https://www.pedigree.com/cdn-cgi/image/height=360,f=auto,quality=90/sites/g/files/fnmzdf3076/files/2023-05/what-breed-my-dog-540x300.png',
                    fit: BoxFit.contain,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 16);
              },
            ),
          ],
        ),
      ),
    );
  }
}
