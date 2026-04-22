import 'package:flutter/material.dart';

class AppPage<T> extends MaterialPage<T> {
  const AppPage({required String super.name, required super.child});

  @override
  Route<T> createRoute(BuildContext context) {
    return _AppPageRoute<T>(page: this);
  }
}

class _AppPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
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

  @override
  bool get isCurrent {
    if (!super.isCurrent) {
      return false;
    }

    var isTrulyCurrent = true;
    ModalRoute? parentRoute = ModalRoute.of(navigator!.context);

    while (parentRoute != null) {
      if (!parentRoute.isCurrent) {
        isTrulyCurrent = false;
        break;
      }
      final parentNav = parentRoute.navigator;
      if (parentNav == null) {
        break;
      }
      parentRoute = ModalRoute.of(parentNav.context);
    }

    if (!isTrulyCurrent) {
      return false;
    }
    return true;
  }
}
