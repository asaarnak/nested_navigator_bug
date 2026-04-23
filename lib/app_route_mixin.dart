import 'package:flutter/material.dart';

mixin AppRouteMixin<T> on ModalRoute<T> {
  /// Whether this route is the top-most route in its local navigator.
  bool get isLocallyCurrent => super.isCurrent;

  @override
  bool get isCurrent {
    // 1. If we aren't top of our local stack, we aren't current.
    if (!isLocallyCurrent) return false;

    // 2. If our navigator is inside another route, that parent route
    // must also be current (locally).
    final parentRoute = ModalRoute.of(navigator!.context);
    if (parentRoute != null) {
      final bool parentIsLocallyCurrent = parentRoute is AppRouteMixin
          ? (parentRoute as AppRouteMixin).isLocallyCurrent
          : parentRoute.isCurrent;
      if (!parentIsLocallyCurrent) return false;
    }

    // 3. Deeper check: Is there a focused navigator INSIDE us that can pop?
    // If so, that nested navigator's top route is the one that's truly current.
    final focus = FocusManager.instance.primaryFocus;
    final activeNavigator =
        focus?.context != null ? Navigator.maybeOf(focus!.context!) : null;
    if (activeNavigator != null &&
        activeNavigator != navigator &&
        activeNavigator.canPop()) {
      // ONLY return false if the active navigator is actually hosted within THIS route.
      if (ModalRoute.of(activeNavigator.context) == this) {
        return false;
      }
    }

    // 4. Bottom check: If we are at the bottom of a nested navigator, we are
    // NOT globally current because our parent route should handle the pop.
    if (parentRoute != null &&
        parentRoute is AppRouteMixin &&
        !navigator!.canPop()) {
      return false;
    }

    return true;
  }
}
