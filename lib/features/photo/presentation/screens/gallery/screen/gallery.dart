import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;
import '../../../provider/index.dart';
import '../../../../../../shared/presentation/widgets/index.dart'
    show MessageView;
import '../widgets/index.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const CameraButton(),

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),

          slivers: [
            const GalleryAppBar(),

            BlocConsumer<PhotoCubit, PhotoState>(
              listener: (context, state) {
                if (state is PhotoFailure) {
                  final stateError = state.error;
                  if (stateError == null) return;

                  final message = stateError.type.message;
                  final messanger = ScaffoldMessenger.of(context);

                  messanger.showSnackBar(SnackBar(content: Text(message)));
                }
              },

              builder: (context, state) {
                final responsive = context.watch<ResponsiveSizeCubit>();

                return _buildContentSliver(
                  state: state,
                  responsive: responsive,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSliver({
    required PhotoState state,
    required ResponsiveSizeCubit responsive,
  }) {
    final photos = state.photos?.photosList;
    bool needsSliverWrapper = true;

    Widget content = const MessageView(message: 'Woops, something went wrong');

    if (photos != null) {
      if (photos.isEmpty) {
        content = const MessageView(message: 'No photos yet');
      } else {
        content = PhotosList(photos: photos);
        needsSliverWrapper = false;
      }
    } else if (state is PhotoInitial || state is PhotoLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (state is PhotoFailure) {
      content = const MessageView(message: 'Error loading photos');
    }

    final internalSliver = needsSliverWrapper
        ? SliverFillRemaining(child: content)
        : content;

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.screenHPadding,
      ).copyWith(bottom: responsive.screenBPadding),
      sliver: internalSliver,
    );
  }
}
