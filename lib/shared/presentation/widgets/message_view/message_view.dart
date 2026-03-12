import 'package:flutter/material.dart';

import '../themed_text/themed_text.dart';

class MessageView extends StatelessWidget {
  const MessageView({super.key, this.message = 'Woops, something went wrong'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ThemedText(
        text: message,
        styleType: AppTextStyle.bodyLarge,
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
      ),
    );
  }
}
