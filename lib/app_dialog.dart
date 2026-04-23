import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_route_mixin.dart';

const double _defaultScrollControlDisabledMaxHeightRatio = 9.0 / 16.0;

class AppBottomSheet<T> extends Page<T> {
  AppBottomSheet({
    required String name,
    this.capturedThemes,
    this.barrierLabel,
    this.barrierOnTapHint,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.enableDrag = true,
    this.showDragHandle,
    this.isScrollControlled = true,
    this.scrollControlDisabledMaxHeightRatio =
        _defaultScrollControlDisabledMaxHeightRatio,
    this.routeSettings,
    this.requestFocus,
    this.transitionAnimationController,
    this.anchorPoint,
    this.useSafeArea = false,
    this.sheetAnimationStyle,
    required this.child,
  }) : super(name: name, key: ValueKey(name));

  /// Stores a list of captured [InheritedTheme]s that are wrapped around the
  /// bottom sheet.
  ///
  /// Consider setting this attribute when the [ModalBottomSheetRoute]
  /// is created through [Navigator.push] and its friends.
  final CapturedThemes? capturedThemes;

  /// Specifies whether this is a route for a bottom sheet that will utilize
  /// [DraggableScrollableSheet].
  ///
  /// Consider setting this parameter to true if this bottom sheet has
  /// a scrollable child, such as a [ListView] or a [GridView],
  /// to have the bottom sheet be draggable.
  final bool isScrollControlled;

  /// The max height constraint ratio for the bottom sheet
  /// when [isScrollControlled] is set to false,
  /// no ratio will be applied when [isScrollControlled] is set to true.
  ///
  /// Defaults to 9 / 16.
  final double scrollControlDisabledMaxHeightRatio;

  /// The bottom sheet's background color.
  ///
  /// Defines the bottom sheet's [Material.color].
  ///
  /// If this property is not provided, it falls back to [Material]'s default.
  final Color? backgroundColor;

  /// The z-coordinate at which to place this material relative to its parent.
  ///
  /// This controls the size of the shadow below the material.
  ///
  /// Defaults to 0, must not be negative.
  final double? elevation;

  /// The shape of the bottom sheet.
  ///
  /// Defines the bottom sheet's [Material.shape].
  ///
  /// If this property is not provided, it falls back to [Material]'s default.
  final ShapeBorder? shape;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defines the bottom sheet's [Material.clipBehavior].
  ///
  /// Use this property to enable clipping of content when the bottom sheet has
  /// a custom [shape] and the content can extend past this shape. For example,
  /// a bottom sheet with rounded corners and an edge-to-edge [Image] at the
  /// top.
  ///
  /// If this property is null, the [BottomSheetThemeData.clipBehavior] of
  /// [ThemeData.bottomSheetTheme] is used. If that's null, the behavior defaults to [Clip.none]
  /// will be [Clip.none].
  final Clip? clipBehavior;

  /// Defines minimum and maximum sizes for a [BottomSheet].
  ///
  /// If null, the ambient [ThemeData.bottomSheetTheme]'s
  /// [BottomSheetThemeData.constraints] will be used. If that
  /// is null and [ThemeData.useMaterial3] is true, then the bottom sheet
  /// will have a max width of 640dp. If [ThemeData.useMaterial3] is false, then
  /// the bottom sheet's size will be constrained by its parent
  /// (usually a [Scaffold]). In this case, consider limiting the width by
  /// setting smaller constraints for large screens.
  ///
  /// If constraints are specified (either in this property or in the
  /// theme), the bottom sheet will be aligned to the bottom-center of
  /// the available space. Otherwise, no alignment is applied.
  final BoxConstraints? constraints;

  /// Specifies the color of the modal barrier that darkens everything below the
  /// bottom sheet.
  ///
  /// Defaults to `Colors.black54` if not provided.
  final Color? modalBarrierColor;

  /// Specifies whether the bottom sheet will be dismissed
  /// when user taps on the scrim.
  ///
  /// If true, the bottom sheet will be dismissed when user taps on the scrim.
  ///
  /// Defaults to true.
  final bool isDismissible;

  /// Specifies whether the bottom sheet can be dragged up and down
  /// and dismissed by swiping downwards.
  ///
  /// If true, the bottom sheet can be dragged up and down and dismissed by
  /// swiping downwards.
  ///
  /// This applies to the content below the drag handle, if showDragHandle is true.
  ///
  /// Defaults is true.
  final bool enableDrag;

  /// Specifies whether a drag handle is shown.
  ///
  /// The drag handle appears at the top of the bottom sheet. The default color is
  /// [ColorScheme.onSurfaceVariant] with an opacity of 0.4 and can be customized
  /// using dragHandleColor. The default size is `Size(32,4)` and can be customized
  /// with dragHandleSize.
  ///
  /// If null, then the value of [BottomSheetThemeData.showDragHandle] is used. If
  /// that is also null, defaults to false.
  final bool? showDragHandle;

  /// The animation controller that controls the bottom sheet's entrance and
  /// exit animations.
  ///
  /// The BottomSheet widget will manipulate the position of this animation, it
  /// is not just a passive observer.
  final AnimationController? transitionAnimationController;

  /// {@macro flutter.widgets.DisplayFeatureSubScreen.anchorPoint}
  final Offset? anchorPoint;

  /// Whether to avoid system intrusions on the top, left, and right.
  ///
  /// If true, a [SafeArea] is inserted to keep the bottom sheet away from
  /// system intrusions at the top, left, and right sides of the screen.
  ///
  /// If false, the bottom sheet will extend through any system intrusions
  /// at the top, left, and right.
  ///
  /// If false, then moreover [MediaQuery.removePadding] will be used
  /// to remove top padding, so that a [SafeArea] widget inside the bottom
  /// sheet will have no effect at the top edge. If this is undesired, consider
  /// setting [useSafeArea] to true. Alternatively, wrap the [SafeArea] in a
  /// [MediaQuery] that restates an ambient [MediaQueryData] from outside [builder].
  ///
  /// In either case, the bottom sheet extends all the way to the bottom of
  /// the screen, including any system intrusions.
  ///
  /// The default is false.
  final bool useSafeArea;

  /// Used to override the modal bottom sheet animation duration and reverse
  /// animation duration.
  ///
  /// If [AnimationStyle.duration] is provided, it will be used to override
  /// the modal bottom sheet animation duration in the underlying
  /// [BottomSheet.createAnimationController].
  ///
  /// If [AnimationStyle.reverseDuration] is provided, it will be used to
  /// override the modal bottom sheet reverse animation duration in the
  /// underlying [BottomSheet.createAnimationController].
  ///
  /// To disable the modal bottom sheet animation, use [AnimationStyle.noAnimation].
  final AnimationStyle? sheetAnimationStyle;

  /// {@template flutter.material.ModalBottomSheetRoute.barrierOnTapHint}
  /// The semantic hint text that informs users what will happen if they
  /// tap on the widget. Announced in the format of 'Double tap to ...'.
  ///
  /// If the field is null, the default hint will be used, which results in
  /// announcement of 'Double tap to activate'.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [barrierDismissible], which controls the behavior of the barrier when
  ///    tapped.
  ///  * [ModalBarrier], which uses this field as onTapHint when it has an onTap action.
  final String? barrierOnTapHint;

  final String? barrierLabel;

  Color get barrierColor => modalBarrierColor ?? Colors.black54;

  final RouteSettings? routeSettings;

  final bool? requestFocus;

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    // ignore: prefer_asserts_with_message
    assert(debugCheckHasMediaQuery(context));
    // ignore: prefer_asserts_with_message
    assert(debugCheckHasMaterialLocalizations(context));

    // final NavigatorState navigator = Navigator.of(
    //   context,
    // );
    final localizations = MaterialLocalizations.of(context);
    return _AppModalBottomSheetRoute<T>(
      builder: (context) => _PredictiveBackDialogWrapper(child: child),
      // capturedThemes: InheritedTheme.capture(
      //   from: context,
      //   to: navigator.context,
      // ),
      isScrollControlled: isScrollControlled,
      scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
      barrierLabel: barrierLabel ?? localizations.scrimLabel,
      barrierOnTapHint: localizations.scrimOnTapHint(
        localizations.bottomSheetLabel,
      ),
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      isDismissible: isDismissible,
      modalBarrierColor: barrierColor,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      settings: this,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      useSafeArea: useSafeArea,
      sheetAnimationStyle: sheetAnimationStyle,
      requestFocus: requestFocus,
    );
  }
}

class _AppModalBottomSheetRoute<T> extends ModalBottomSheetRoute<T>
    with AppRouteMixin<T> {
  _AppModalBottomSheetRoute({
    required super.builder,
    super.capturedThemes,
    super.barrierLabel,
    super.barrierOnTapHint,
    super.backgroundColor,
    super.elevation,
    super.shape,
    super.clipBehavior,
    super.constraints,
    super.modalBarrierColor,
    super.isDismissible,
    super.enableDrag,
    super.showDragHandle,
    required super.isScrollControlled,
    super.scrollControlDisabledMaxHeightRatio,
    super.settings,
    super.transitionAnimationController,
    super.anchorPoint,
    super.useSafeArea,
    super.sheetAnimationStyle,
    super.requestFocus,
  });
}

class AppDialog<T> extends Page<T> {
  AppDialog({
    required this.child,
    required String name,
    this.transitionDuration = const Duration(milliseconds: 350),
    this.reverseTransitionDuration = const Duration(milliseconds: 500),
    this.entryCurve = const Cubic(0.42, 1.67, 0.21, 0.90),
    this.exitCurve = const Cubic(0.38, 1.21, 0.22, 1),
    this.fullscreenDialog = false,
    this.barrierColor,
    this.barrierDismissible = true,
    this.barrierLabel,
    super.arguments,
    super.canPop,
  }) : super(name: name, key: ValueKey(name));

  final Widget child;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final Curve entryCurve;
  final Curve exitCurve;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool fullscreenDialog;

  @override
  AppRawDialogRoute<T> createRoute(BuildContext context) {
    return AppRawDialogRoute<T>(
      settings: this,
      fullscreenDialog: fullscreenDialog,
      barrierColor: barrierColor ?? Colors.black54,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      pageBuilder: (context, animation, secondaryAnimation) =>
          _PredictiveBackDialogWrapper(child: child),
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: entryCurve,
          reverseCurve: exitCurve,
        );
        return ScaleTransition(scale: curvedAnimation, child: child);
      },
    );
  }
}

class AppDialogPage<T> extends Page<T> {
  AppDialogPage({
    required this.child,
    required String name,
    this.transitionDuration = const Duration(milliseconds: 350),
    this.reverseTransitionDuration = const Duration(milliseconds: 500),
    this.entryCurve = const Cubic(0.42, 1.67, 0.21, 0.90),
    this.exitCurve = const Cubic(0.38, 1.21, 0.22, 1),
    this.barrierColor,
    this.barrierDismissible = true,
    this.barrierLabel,
    super.arguments,
  }) : super(name: name, key: ValueKey(name));
  final Widget child;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final Curve entryCurve;
  final Curve exitCurve;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;

  @override
  Route<T> createRoute(BuildContext context) {
    return _AppPageRouteBuilder<T>(
      settings: this,
      allowSnapshotting: false,
      // These are essential for a dialog-like route
      opaque: false,
      barrierColor: barrierColor ?? Colors.black54,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,

      pageBuilder: (context, animation, secondaryAnimation) =>
          _PredictiveBackDialogWrapper(child: child),

      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,

      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: entryCurve,
          reverseCurve: exitCurve,
        );

        return ScaleTransition(scale: curvedAnimation, child: child);
      },
    );
  }
}

class _AppPageRouteBuilder<T> extends PageRouteBuilder<T> with AppRouteMixin<T> {
  _AppPageRouteBuilder({
    super.settings,
    required super.pageBuilder,
    super.transitionsBuilder,
    super.transitionDuration,
    super.reverseTransitionDuration,
    super.opaque,
    super.barrierDismissible,
    super.barrierColor,
    super.barrierLabel,
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
  });
}

class AppRawDialogRoute<T> extends RawDialogRoute<T> with AppRouteMixin<T> {
  AppRawDialogRoute({
    required super.pageBuilder,
    super.barrierDismissible,
    super.barrierColor,
    super.barrierLabel,
    super.transitionDuration,
    super.transitionBuilder,
    super.settings,
    super.requestFocus,
    super.anchorPoint,
    super.traversalEdgeBehavior,
    super.directionalTraversalEdgeBehavior,
    super.fullscreenDialog,
    Duration? reverseTransitionDuration,
  }) : _reverseTransitionDuration = reverseTransitionDuration;
  final Duration? _reverseTransitionDuration;
  @override
  Duration get reverseTransitionDuration =>
      _reverseTransitionDuration ?? transitionDuration;
  @override
  bool get allowSnapshotting => false;
}

class _PredictiveBackDialogWrapper extends StatefulWidget {
  const _PredictiveBackDialogWrapper({required this.child});
  final Widget child;

  @override
  State<_PredictiveBackDialogWrapper> createState() =>
      _PredictiveBackDialogWrapperState();
}

class _PredictiveBackDialogWrapperState
    extends State<_PredictiveBackDialogWrapper>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final AnimationController _backGestureController;
  late final AnimationController _commitController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _borderRadiusAnimation;
  late final Animation<Offset> _translationAnimation;

  bool _isBackGestureActive = false;
  double _swipeEdge = 0; // 1.0 for left edge, -1.0 for right edge
  PredictiveBackEvent? _startBackEvent;
  PredictiveBackEvent? _currentBackEvent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _backGestureController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _commitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // M3 Spec: Uniform 0.9 shrink
    _scaleAnimation = Tween<double>(begin: 1, end: 0.90).animate(
      CurvedAnimation(
        parent: _backGestureController,
        curve: Curves.easeOutCubic,
      ),
    );

    // M3 Spec: Smooth radius interpolation
    _borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _backGestureController,
        curve: Curves.easeOutCubic,
      ),
    );

    // X translation 8dp
    _translationAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(8, 0)).animate(
          CurvedAnimation(
            parent: _backGestureController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _backGestureController.dispose();
    _commitController.dispose();
    super.dispose();
  }

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    if (ModalRoute.of(context)?.isCurrent != true) {
      return false;
    }

    _isBackGestureActive = true;
    _swipeEdge = backEvent.swipeEdge == SwipeEdge.left ? 1.0 : -1.0;
    _startBackEvent = backEvent;
    _currentBackEvent = backEvent;
    _backGestureController.value = backEvent.progress;
    return true;
  }

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {
    if (_isBackGestureActive) {
      _currentBackEvent = backEvent;
      _backGestureController.value = backEvent.progress;
    }
  }

  @override
  void handleCommitBackGesture() {
    if (_isBackGestureActive) {
      _isBackGestureActive = false;
      // In Android 14 standard: The element fades out entirely smoothly via easeInOutCubicEmphasized.
      _commitController.duration = const Duration(milliseconds: 400);
      unawaited(_commitController.forward());
      unawaited(Navigator.of(context).maybePop());
    }
  }

  @override
  void handleCancelBackGesture() {
    if (_isBackGestureActive) {
      unawaited(_backGestureController.reverse());
      _isBackGestureActive = false;
      _startBackEvent = null;
      _currentBackEvent = null;
    }
  }

  double _getYShiftPosition(double screenHeight) {
    if (_startBackEvent == null || _currentBackEvent == null) {
      return 0;
    }
    final startTouchY = _startBackEvent!.touchOffset?.dy ?? 0;
    final currentTouchY = _currentBackEvent!.touchOffset?.dy ?? 0;

    final rawYShift = currentTouchY - startTouchY;
    final normalizedShift = (rawYShift.abs() / screenHeight).clamp(0.0, 1.0);
    // Maps to the 10% vertical position shifting factor
    return Curves.easeOut.transform(normalizedShift) *
        rawYShift.sign *
        (screenHeight * 0.1);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_backGestureController, _commitController]),
      builder: (context, child) {
        final currentOffset = _translationAnimation.value * _swipeEdge;
        final screenHeight = MediaQuery.sizeOf(context).height;
        final yShift = _getYShiftPosition(screenHeight);

        // Hardware device radius extraction with fallback to 32 (Flutter default fallback)
        final dynamicRadius =
            // TODO on master or beta branch use this: MediaQuery.displayCornerRadiiOf(context) ??
            BorderRadius.circular(32);

        final activeRadius = BorderRadius.lerp(
          BorderRadius.zero,
          dynamicRadius,
          _borderRadiusAnimation.value,
        )!;

        // Custom commit opacity logic using the M3 standard 1.0 -> 0.0 fade
        final commitFade = Tween<double>(begin: 1, end: 0).evaluate(
          CurvedAnimation(
            parent: _commitController,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        );

        return Transform.translate(
          offset: Offset(currentOffset.dx, yShift),
          child: Opacity(
            opacity: commitFade,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: ClipRRect(borderRadius: activeRadius, child: child),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
