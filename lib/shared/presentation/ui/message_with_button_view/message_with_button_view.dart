import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../providers/responsive_size/index.dart';
import '../themed_text/themed_text.dart';

class MessageWithButtonView extends StatelessWidget {
  const MessageWithButtonView({
    super.key,
    this.message = 'Woops, something went wrong',
    this.buttonText = 'Retry',
    required this.onPressed,
  });

  final String message;
  final String buttonText;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final responsiveSizeCubit = context.watch<ResponsiveSizeCubit>();
    final screenVPadding = responsiveSizeCubit.screenVPadding;
    final screenHPadding = responsiveSizeCubit.screenHPadding;
    final spacing = responsiveSizeCubit.spacingM;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenHPadding,
          vertical: screenVPadding,
        ),
        child: Column(
          spacing: spacing,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThemedText(
              text: message,
              styleType: AppTextStyle.bodyLarge,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),

            ElevatedButton(
              onPressed: onPressed,
              child: ThemedText(
                text: buttonText,
                styleType: AppTextStyle.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
