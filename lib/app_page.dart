import 'package:flutter/material.dart';

import 'app_route_mixin.dart';

class AppPage<T> extends MaterialPage<T> {
  const AppPage({required String super.name, required super.child});

  @override
  Route<T> createRoute(BuildContext context) {
    return _AppPageRoute<T>(page: this);
  }
}

class _AppPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T>, AppRouteMixin<T> {
  _AppPageRoute({required MaterialPage<T> page}) : super(settings: page);

  @override
  Widget buildContent(BuildContext context) {
    return (settings as MaterialPage<T>).child;
  }

  @override
  bool get maintainState => (settings as MaterialPage<T>).maintainState;

  @override
  bool get fullscreenDialog => (settings as MaterialPage<T>).fullscreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}
