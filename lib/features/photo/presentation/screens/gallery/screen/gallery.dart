import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../shared/presentation/providers/responsive_size/index.dart'
    show ResponsiveSizeCubit;
import '../../../provider/index.dart';
import '../utils/photo_error_messages.dart';
import '../widgets/app_bar.dart';
import '../widgets/camera_button.dart';
import '../../../../../../shared/presentation/ui/index.dart' show MessageView;
import '../widgets/photos_list/ui/photos_list.dart';

@RoutePage()
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CameraButton(),

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),

          slivers: [
            const AppBarWidget(),

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
                final responsiveSizeCubit = context
                    .watch<ResponsiveSizeCubit>();

                return _buildContentSliver(
                  state: state,
                  responsiveSizeCubit: responsiveSizeCubit,
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
    required ResponsiveSizeCubit responsiveSizeCubit,
  }) {
    final photoPathsList = state.photoPathsList;
    bool needsSliverWrapper = true;

    Widget content = const MessageView(message: 'Woops, something went wrong');

    if (photoPathsList != null) {
      if (photoPathsList.isEmpty) {
        content = const MessageView(message: 'No photos yet');
      } else {
        content = PhotosList(photoPathsList: photoPathsList);

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

    final screenVPadding = responsiveSizeCubit.screenVPadding;
    final screenHPadding = responsiveSizeCubit.screenHPadding;

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: screenHPadding,
        vertical: screenVPadding,
      ),
      sliver: internalSliver,
    );
  }
}
