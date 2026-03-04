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
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final responsive = context.watch<ResponsiveSizeCubit>();
    final screenVPadding = responsive.screenVPadding;
    final screenHPadding = responsive.screenHPadding;
    final spacing = responsive.spacingM;

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

            ElevatedButton(onPressed: onPressed, child: Text(buttonText)),
          ],
        ),
      ),
    );
  }
}
