import 'package:talker_flutter/talker_flutter.dart' show Talker;

import 'navigation/index.dart' show AppRouter;

class AppConfig {
  AppConfig({required this.talker, required this.router});

  final Talker talker;
  final AppRouter router;
}
