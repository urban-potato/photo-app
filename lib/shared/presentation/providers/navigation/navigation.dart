import 'package:flutter/material.dart' show BuildContext;

import 'types/app_routes.dart';

abstract interface class NavigationProviderI {
  void push(BuildContext context, AppRoute route);
  void pop(BuildContext context);
  void maybePop(BuildContext context);
  void popToFirst(BuildContext context);
}
