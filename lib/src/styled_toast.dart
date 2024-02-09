import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'styled_toast_animation.dart';
import 'styled_toast_enums.dart';
import 'styled_toast_manager.dart';
import 'styled_toast_theme.dart';

/// Current context of the page which uses the toast.
BuildContext? currentContext;

/// Default toast duration for showing.
const _defaultDuration = Duration(milliseconds: 2300);

/// Default animation duration.
const animationDuration = Duration(milliseconds: 400);

/// The default horizontal margin of toast.
const double _defaultHorizontalMargin = 50.0;

/// Callback of the life cycle hook [initState] of toast widget.
///
/// When the life cycle [initState] of toast widget is called, this callback will be called,
/// the duration of toast [toastDuration] and animation [animDuration] will pass over.
typedef OnInitStateCallback = Function(
  Duration toastDuration,
  Duration animDuration,
);

/// Show normal toast with style and animation.
///
/// Can be used without wrapping you app with StyledToast, but must specify context,
/// When you wrap your app with StyledToast, [context] is optional,
/// [animationBuilder] If not null, [animation] is not working,
/// [reverseAnimBuilder] If not null, [reverseAnimation] is not working.
StyledToastFuture showToast(
  final String? msg, {
  BuildContext? context,
  final Duration? duration,
  final Duration? animDuration,
  StyledToastPosition? position,
  TextStyle? textStyle,
  EdgeInsetsGeometry? textPadding,
  final double toastHorizontalMargin = _defaultHorizontalMargin,
  Color? backgroundColor,
  BorderRadius? borderRadius,
  ShapeBorder? shapeBorder,
  final VoidCallback? onDismiss,
  TextDirection? textDirection,
  final bool? dismissOtherToast,
  final StyledToastAnimationType? animation,
  final StyledToastAnimationType? reverseAnimation,
  final Alignment? alignment,
  final Axis? axis,
  final Offset? startOffset,
  final Offset? endOffset,
  final Offset? reverseStartOffset,
  final Offset? reverseEndOffset,
  TextAlign? textAlign,
  final Curve? curve,
  final Curve? reverseCurve,
  bool? fullWidth,
  final bool? isHideKeyboard,
  final StyledToastAnimationBuilder? animationBuilder,
  final StyledToastAnimationBuilder? reverseAnimBuilder,
  final bool? isIgnoring,
  final OnInitStateCallback? onInitState,
}) {
  context ??= currentContext;
  assert(context != null);

  final toastTheme = StyledToastTheme.maybeOf(context!);

  position ??= toastTheme?.toastPositions ?? StyledToastPosition.bottom;

  textStyle ??= toastTheme?.textStyle ?? const TextStyle(fontSize: 16.0, color: Colors.white);

  textPadding ??= toastTheme?.textPadding ?? const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0);

  backgroundColor ??= toastTheme?.backgroundColor ?? const Color(0x99000000);
  borderRadius ??= toastTheme?.borderRadius ?? BorderRadius.circular(5.0);

  shapeBorder ??= toastTheme?.shapeBorder ??
      RoundedRectangleBorder(
        borderRadius: borderRadius,
      );

  textDirection ??= toastTheme?.textDirection ?? TextDirection.ltr;

  textAlign ??= toastTheme?.textAlign ?? TextAlign.center;

  fullWidth ??= toastTheme?.fullWidth ?? false;

  final widget = Container(
    margin: EdgeInsets.symmetric(horizontal: toastHorizontalMargin),
    width: fullWidth ? MediaQuery.of(context).size.width - (toastHorizontalMargin) : null,
    decoration: ShapeDecoration(
      color: backgroundColor,
      shape: shapeBorder,
    ),
    padding: textPadding,
    child: Text(
      msg ?? '',
      style: textStyle,
      textAlign: textAlign,
    ),
  );

  return showToastWidget(
    widget,
    context: context,
    duration: duration,
    animDuration: animDuration,
    onDismiss: onDismiss,
    position: position,
    dismissOtherToast: dismissOtherToast,
    textDirection: textDirection,
    alignment: alignment,
    axis: axis,
    startOffset: startOffset,
    endOffset: endOffset,
    reverseStartOffset: reverseStartOffset,
    reverseEndOffset: reverseEndOffset,
    curve: curve,
    reverseCurve: reverseCurve,
    animation: animation,
    reverseAnimation: reverseAnimation,
    isHideKeyboard: isHideKeyboard,
    animationBuilder: animationBuilder,
    reverseAnimBuilder: reverseAnimBuilder,
    isIgnoring: isIgnoring,
    onInitState: onInitState,
  );
}

/// Show custom content widget for toasting.
StyledToastFuture showToastWidget(
  Widget widget, {
  BuildContext? context,
  Duration? duration,
  Duration? animDuration,
  VoidCallback? onDismiss,
  bool? dismissOtherToast,
  TextDirection? textDirection,
  Alignment? alignment,
  Axis? axis,
  Offset? startOffset,
  Offset? endOffset,
  Offset? reverseStartOffset,
  Offset? reverseEndOffset,
  StyledToastPosition? position,
  StyledToastAnimationType? animation,
  StyledToastAnimationType? reverseAnimation,
  Curve? curve,
  Curve? reverseCurve,
  bool? isHideKeyboard,
  StyledToastAnimationBuilder? animationBuilder,
  StyledToastAnimationBuilder? reverseAnimBuilder,
  bool? isIgnoring,
  OnInitStateCallback? onInitState,
}) {
  OverlayEntry entry;
  StyledToastFuture future;

  context ??= currentContext;
  assert(context != null);

  final toastTheme = StyledToastTheme.maybeOf(context!);

  isHideKeyboard ??= toastTheme?.isHideKeyboard ?? false;

  duration ??= toastTheme?.duration ?? _defaultDuration;

  animDuration ??= toastTheme?.animDuration ?? animationDuration;

  dismissOtherToast ??= toastTheme?.dismissOtherOnShow ?? true;

  textDirection ??= textDirection ?? toastTheme?.textDirection ?? TextDirection.ltr;

  position ??= toastTheme?.toastPositions ?? StyledToastPosition.bottom;

  alignment ??= toastTheme?.alignment ?? Alignment.center;

  axis ??= toastTheme?.axis ?? Axis.vertical;

  startOffset ??= toastTheme?.startOffset;

  endOffset ??= toastTheme?.endOffset;

  reverseStartOffset ??= toastTheme?.reverseStartOffset;

  reverseEndOffset ??= toastTheme?.reverseEndOffset;

  curve ??= curve ?? toastTheme?.curve ?? Curves.linear;

  reverseCurve ??= reverseCurve ?? toastTheme?.reverseCurve ?? Curves.linear;

  animation ??= animation ?? toastTheme?.toastAnimation ?? StyledToastAnimationType.size;

  reverseAnimation ??= reverseAnimation ?? toastTheme?.reverseAnimation ?? StyledToastAnimationType.size;

  animationBuilder ??= animationBuilder ?? toastTheme?.animationBuilder;

  reverseAnimBuilder ??= reverseAnimBuilder ?? toastTheme?.reverseAnimBuilder;

  onInitState ??= onInitState ?? toastTheme?.onInitState;

  onDismiss ??= onDismiss ?? toastTheme?.onDismiss;

  isIgnoring ??= toastTheme?.isIgnoring ?? true;

  if (isHideKeyboard) {
    /// Hide keyboard.
    FocusScope.of(context).requestFocus(FocusNode());
  }

  GlobalKey<StyledToastWidgetState> key = GlobalKey();

  entry = OverlayEntry(builder: (ctx) {
    return IgnorePointer(
      ignoring: isIgnoring!,
      child: _StyledToastWidget(
        duration: duration!,
        animDuration: animDuration!,
        position: position,
        animation: animation,
        reverseAnimation: reverseAnimation,
        alignment: alignment,
        axis: axis,
        startOffset: startOffset,
        endOffset: endOffset,
        reverseStartOffset: reverseStartOffset,
        reverseEndOffset: reverseEndOffset,
        curve: curve!,
        reverseCurve: reverseCurve!,
        key: key,
        animationBuilder: animationBuilder,
        reverseAnimBuilder: reverseAnimBuilder,
        onInitState: onInitState,
        child: Directionality(
          textDirection: textDirection!,
          child: Material(
            child: widget,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  });

  if (dismissOtherToast) {
    dismissAllToast();
  }

  future = StyledToastFuture.create(duration, entry, onDismiss, key);

  Overlay.of(context).insert(entry);
  StyledToastManager().addFuture(future);

  return future;
}

/// Toast configuration widget, which we use to save the overall configuration
/// for toast widget in.
class StyledToast extends StatefulWidget {
  /// Child of toast scope.
  final Widget child;

  /// Text align.
  final TextAlign? textAlign;

  /// Text direction.
  final TextDirection? textDirection;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Background color.
  final Color? backgroundColor;

  /// Padding for the text and the container edges.
  final EdgeInsets? textPadding;

  /// Text style for content.
  final TextStyle? textStyle;

  /// Shape for the container.
  final ShapeBorder? shapeBorder;

  /// Toast show duration.
  final Duration? duration;

  /// Toast animation duration.
  final Duration? animDuration;

  /// Position of the toast widget in current window.
  final StyledToastPosition? toastPositions;

  /// Toast animation.
  final StyledToastAnimationType? toastAnimation;

  /// Toast reverse animation.
  final StyledToastAnimationType? reverseAnimation;

  /// Alignment of animation, like size, rotate animation.
  final Alignment? alignment;

  /// Axis of animation, like size animation.
  final Axis? axis;

  /// Start offset of slide animation.
  final Offset? startOffset;

  /// End offset of slide animation.
  final Offset? endOffset;

  /// Start offset of reverse slide animation.
  final Offset? reverseStartOffset;

  /// End offset of reverse slide animation.
  final Offset? reverseEndOffset;

  /// Animation curve.
  final Curve? curve;

  /// Animation reverse curve.
  final Curve? reverseCurve;

  /// callback when toast dismissed.
  final VoidCallback? onDismiss;

  /// Dismiss old toast when new one shows.
  final bool? dismissOtherOnShow;

  /// The locale of the app.
  final Locale locale;

  /// Full width that the width of the screen minus the width of the margin.
  final bool? fullWidth;

  /// Is hide keyboard when toast show.
  final bool? isHideKeyboard;

  /// Custom animation builder method.
  final StyledToastAnimationBuilder? animationBuilder;

  /// Custom animation builder method.
  final StyledToastAnimationBuilder? reverseAnimBuilder;

  /// Is the input ignored for the toast.
  final bool? isIgnoring;

  /// When toast widget [initState], this callback will be called.
  final OnInitStateCallback? onInitState;

  const StyledToast({
    super.key,
    required this.child,
    this.textAlign,
    this.textDirection,
    this.borderRadius,
    this.backgroundColor,
    this.textPadding,
    this.textStyle = const TextStyle(fontSize: 16.0, color: Colors.white),
    this.shapeBorder,
    this.duration,
    this.animDuration,
    this.toastPositions,
    this.toastAnimation,
    this.reverseAnimation,
    this.alignment,
    this.axis,
    this.startOffset,
    this.endOffset,
    this.reverseStartOffset,
    this.reverseEndOffset,
    this.curve,
    this.reverseCurve,
    this.dismissOtherOnShow = true,
    this.onDismiss,
    required this.locale,
    this.fullWidth,
    this.isHideKeyboard,
    this.animationBuilder,
    this.reverseAnimBuilder,
    this.isIgnoring = true,
    this.onInitState,
  });

  @override
  State<StatefulWidget> createState() {
    return _StyledToastState();
  }
}

class _StyledToastState extends State<StyledToast> {
  @override
  Widget build(final BuildContext context) {
    final overlay = Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(builder: (context) {
          currentContext = context;
          return widget.child;
        })
      ],
    );

    final textDirection = widget.textDirection ?? TextDirection.ltr;

    final wrapper = Directionality(
      textDirection: textDirection,
      child: Stack(
        children: <Widget>[
          overlay,
        ],
      ),
    );

    final textStyle = widget.textStyle ??
        const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        );

    final backgroundColor = widget.backgroundColor ?? const Color(0x99000000);

    final borderRadius = widget.borderRadius ?? BorderRadius.circular(5.0);

    final textAlign = widget.textAlign ?? TextAlign.center;
    final textPadding = widget.textPadding ??
        const EdgeInsets.symmetric(
          horizontal: 17.0,
          vertical: 8.0,
        );

    return Localizations(
      delegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: widget.locale,
      child: StyledToastTheme(
        textAlign: textAlign,
        textDirection: textDirection,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        textPadding: textPadding,
        textStyle: textStyle,
        shapeBorder: widget.shapeBorder,
        duration: widget.duration,
        animDuration: widget.animDuration,
        toastPositions: widget.toastPositions,
        toastAnimation: widget.toastAnimation,
        reverseAnimation: widget.reverseAnimation,
        alignment: widget.alignment,
        axis: widget.axis,
        startOffset: widget.startOffset,
        endOffset: widget.endOffset,
        reverseStartOffset: widget.reverseStartOffset,
        reverseEndOffset: widget.reverseEndOffset,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
        dismissOtherOnShow: widget.dismissOtherOnShow,
        onDismiss: widget.onDismiss,
        fullWidth: widget.fullWidth,
        isHideKeyboard: widget.isHideKeyboard,
        animationBuilder: widget.animationBuilder,
        reverseAnimBuilder: widget.reverseAnimBuilder,
        isIgnoring: widget.isIgnoring,
        onInitState: widget.onInitState,
        child: wrapper,
      ),
    );
  }
}

/// Styled Toast widget.
class _StyledToastWidget extends StatefulWidget {
  /// Child widget.
  final Widget child;

  /// Toast duration.
  final Duration duration;

  /// Toast animation duration.
  final Duration animDuration;

  /// Animation curve.
  final Curve curve;

  /// Animation reverse curve.
  final Curve reverseCurve;

  /// Toast position.
  final StyledToastPosition? position;

  /// Alignment of animation, scale, rotate animation.
  final Alignment? alignment;

  /// Axis of animation, like size animation.
  final Axis? axis;

  /// Start offset of slide animation.
  final Offset? startOffset;

  /// End offset of slide animation.
  final Offset? endOffset;

  /// Start offset of reverse slide animation.
  final Offset? reverseStartOffset;

  /// End offset of reverse slide animation.
  final Offset? reverseEndOffset;

  /// Toast animation.
  final StyledToastAnimationType? animation;

  /// Toast reverse animation.
  final StyledToastAnimationType? reverseAnimation;

  /// Custom animation builder method.
  final StyledToastAnimationBuilder? animationBuilder;

  /// Custom animation builder method.
  final StyledToastAnimationBuilder? reverseAnimBuilder;

  /// Custom animation builder method.
  final OnInitStateCallback? onInitState;

  const _StyledToastWidget({
    super.key,
    required this.child,
    required this.duration,
    required this.animDuration,
    this.curve = Curves.linear,
    this.reverseCurve = Curves.linear,
    this.position = StyledToastPosition.bottom,
    this.alignment = Alignment.center,
    this.axis = Axis.horizontal,
    this.startOffset,
    this.endOffset,
    this.reverseStartOffset,
    this.reverseEndOffset,
    this.animation = StyledToastAnimationType.fade,
    this.reverseAnimation,
    this.animationBuilder,
    this.reverseAnimBuilder,
    this.onInitState,
  }) : assert(animDuration * 2 <= duration || duration == Duration.zero);

  @override
  State<StatefulWidget> createState() {
    return StyledToastWidgetState();
  }
}

class StyledToastWidgetState extends State<_StyledToastWidget> with TickerProviderStateMixin<_StyledToastWidget>, WidgetsBindingObserver {
  /// Animation controller.
  late AnimationController _animationController;

  /// Reverse animation controller.
  late AnimationController _reverseAnimController;

  /// Fade animation.
  late Animation<double> fadeAnim;

  /// Scale animation.
  late Animation<double> scaleAnim;

  /// Size animation.
  late Animation<double> sizeAnim;

  /// Slide from top animation.
  late Animation<Offset> slideFromTopAnim;

  /// Slide from bottom animation.
  late Animation<Offset> slideFromBottomAnim;

  /// Slide from left animation.
  late Animation<Offset> slideFromLeftAnim;

  /// Slide from right animation.
  late Animation<Offset> slideFromRightAnim;

  /// Fade scale animation.
  late Animation<double> fadeScaleAnim;

  /// Rotate animation.
  late Animation<double> rotateAnim;

  /// Fade animation reverse.
  late Animation<double> fadeAnimReverse;

  /// Scale animation reverse.
  late Animation<double> scaleAnimReverse;

  /// Size animation reverse.
  late Animation<double> sizeAnimReverse;

  /// Slide from top animation reverse.
  late Animation<Offset> slideToTopAnimReverse;

  /// Slide from bottom animation reverse.
  late Animation<Offset> slideToBottomAnimReverse;

  /// Slide from left animation reverse.
  late Animation<Offset> slideToLeftAnimReverse;

  /// Slide from right animation reverse.
  late Animation<Offset> slideToRightAnimReverse;

  /// Fade scale animation reverse.
  late Animation<double> fadeScaleAnimReverse;

  /// Rotate animation reverse.
  late Animation<double> rotateAnimReverse;

  /// Opacity of this widget.
  double opacity = 1.0;

  /// Toast position offset.
  double? get offset => widget.position?.offset;

  /// Toast alignment in the screen.
  Alignment? get positionAlignment => widget.position?.align;

  /// A [Timer] needed to dismiss the toast with animation.
  ///
  /// After the given [duration] of time, the toast will be dismissed.
  Timer? _toastTimer;

  @override
  void initState() {
    super.initState();

    _initAnim();

    _animationController.forward();

    widget.onInitState?.call(widget.duration, widget.animDuration);

    /// If toast duration is zero, then the toast won't dismiss automatically.
    if (widget.duration != Duration.zero) {
      /// Dismiss toast.
      _toastTimer = Timer(widget.duration - widget.animDuration, () async {
        if (widget.reverseAnimation == StyledToastAnimationType.none) {
          dismissToast();
        } else {
          dismissToastAnim();
        }
      });
    }

    WidgetsBinding.instance.addObserver(this);
  }

  /// Init animation.
  void _initAnim() {
    _animationController = AnimationController(vsync: this, duration: widget.animDuration);

    _reverseAnimController = AnimationController(vsync: this, duration: widget.animDuration);

    switch (widget.animation) {
      case StyledToastAnimationType.fade:
        fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: widget.reverseCurve),
        );
        break;
      case StyledToastAnimationType.slideFromTop:
        slideFromTopAnim = _animationController.drive(
          Tween<Offset>(begin: widget.startOffset ?? const Offset(0.0, -1.0), end: widget.endOffset ?? Offset.zero).chain(
            CurveTween(
              curve: widget.curve,
            ),
          ),
        );
        break;
      case StyledToastAnimationType.slideFromTopFade:
        slideFromTopAnim = _animationController.drive(
          Tween<Offset>(begin: widget.startOffset ?? const Offset(0.0, -1.0), end: widget.endOffset ?? Offset.zero).chain(
            CurveTween(
              curve: widget.curve,
            ),
          ),
        );
        fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: widget.reverseCurve),
        );
        break;
      case StyledToastAnimationType.slideFromBottom:
        slideFromBottomAnim = _animationController.drive(
          Tween<Offset>(begin: widget.startOffset ?? const Offset(0.0, 1.0), end: widget.endOffset ?? Offset.zero).chain(
            CurveTween(
              curve: widget.curve,
            ),
          ),
        );
        break;
      case StyledToastAnimationType.slideFromBottomFade:
        slideFromBottomAnim = _animationController.drive(
          Tween<Offset>(begin: widget.startOffset ?? const Offset(0.0, 1.0), end: widget.endOffset ?? Offset.zero).chain(
            CurveTween(
              curve: widget.curve,
            ),
          ),
        );
        fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: widget.reverseCurve),
        );
        break;
      case StyledToastAnimationType.slideFromLeft:
        slideFromLeftAnim = _animationController.drive(
          Tween<Offset>(begin: widget.startOffset ?? const Offset(-1.0, 0.0), end: widget.endOffset ?? Offset.zero).chain(
            CurveTween(
              curve: widget.curve,
            ),
          ),
        );

        break;
      case StyledToastAnimationType.slideFromLeftFade:
        slideFromLeftAnim = _animationController.drive(
          Tween<Offset>(begin: widget.startOffset ?? const Offset(-1.0, 0.0), end: widget.endOffset ?? Offset.zero).chain(
            CurveTween(
              curve: widget.curve,
            ),
          ),
        );
        fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: widget.reverseCurve),
        );
        break;
      case StyledToastAnimationType.slideFromRight:
        slideFromRightAnim = _animationController.drive(
          Tween<Offset>(begin: widget.startOffset ?? const Offset(1.0, 0.0), end: widget.endOffset ?? Offset.zero).chain(
            CurveTween(
              curve: widget.curve,
            ),
          ),
        );

        break;
      case StyledToastAnimationType.slideFromRightFade:
        slideFromRightAnim = _animationController.drive(
          Tween<Offset>(begin: widget.startOffset ?? const Offset(1.0, 0.0), end: widget.endOffset ?? Offset.zero).chain(
            CurveTween(
              curve: widget.curve,
            ),
          ),
        );
        fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: widget.reverseCurve),
        );
        break;
      case StyledToastAnimationType.size:
        sizeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: widget.reverseCurve),
        );
        break;
      case StyledToastAnimationType.sizeFade:
        sizeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: widget.reverseCurve),
        );

        fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: widget.reverseCurve),
        );
        break;
      case StyledToastAnimationType.scale:
        scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: widget.reverseCurve),
        );
        break;
      case StyledToastAnimationType.fadeScale:
        fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 1.0, curve: widget.curve),
            reverseCurve: Interval(0.0, 1.0, curve: widget.reverseCurve),
          ),
        );
        scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 1.0, curve: widget.curve),
            reverseCurve: Interval(0.0, 1.0, curve: widget.reverseCurve),
          ),
        );
        break;
      case StyledToastAnimationType.rotate:
        rotateAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: widget.reverseCurve),
        );
        break;
      case StyledToastAnimationType.scaleRotate:
        scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 1.0, curve: widget.curve),
            reverseCurve: Interval(0.0, 1.0, curve: widget.reverseCurve),
          ),
        );
        rotateAnim = Tween<double>(begin: 0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 1.0, curve: widget.curve),
            reverseCurve: Interval(0.0, 1.0, curve: widget.reverseCurve),
          ),
        );
        break;
      case StyledToastAnimationType.fadeRotate:
        fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 1.0, curve: widget.curve),
            reverseCurve: Interval(0.0, 1.0, curve: widget.reverseCurve),
          ),
        );
        rotateAnim = Tween<double>(begin: 0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 1.0, curve: widget.curve),
            reverseCurve: Interval(0.0, 1.0, curve: widget.reverseCurve),
          ),
        );
        break;
      case StyledToastAnimationType.none:
        break;
      default:
        fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: widget.reverseCurve),
        );
        break;
    }

    if (widget.reverseAnimation != null) {
      switch (widget.reverseAnimation) {
        case StyledToastAnimationType.fade:
          fadeAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: widget.reverseCurve,
            ),
          );

          break;
        case StyledToastAnimationType.slideToTop:
          slideToTopAnimReverse = _reverseAnimController.drive(
            Tween<Offset>(
              begin: widget.reverseStartOffset ?? Offset.zero,
              end: widget.reverseEndOffset ?? const Offset(0.0, -1.0),
            ).chain(CurveTween(curve: widget.reverseCurve)),
          );

          break;
        case StyledToastAnimationType.slideToTopFade:
          slideToTopAnimReverse = _reverseAnimController.drive(
            Tween<Offset>(
              begin: widget.reverseStartOffset ?? Offset.zero,
              end: widget.reverseEndOffset ?? const Offset(0.0, -1.0),
            ).chain(CurveTween(curve: widget.reverseCurve)),
          );
          fadeAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: widget.reverseCurve,
            ),
          );
          break;
        case StyledToastAnimationType.slideToBottom:
          slideToBottomAnimReverse = _reverseAnimController.drive(
            Tween<Offset>(
              begin: widget.reverseStartOffset ?? Offset.zero,
              end: widget.reverseEndOffset ?? const Offset(0.0, 1.0),
            ).chain(CurveTween(curve: widget.reverseCurve)),
          );
          break;
        case StyledToastAnimationType.slideToBottomFade:
          slideToBottomAnimReverse = _reverseAnimController.drive(
            Tween<Offset>(
              begin: widget.reverseStartOffset ?? Offset.zero,
              end: widget.reverseEndOffset ?? const Offset(0.0, 1.0),
            ).chain(CurveTween(curve: widget.reverseCurve)),
          );
          fadeAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: widget.reverseCurve,
            ),
          );
          break;
        case StyledToastAnimationType.slideToLeft:
          slideToLeftAnimReverse = _reverseAnimController.drive(
            Tween<Offset>(
              begin: widget.reverseStartOffset ?? Offset.zero,
              end: widget.reverseEndOffset ?? const Offset(-1.0, 0.0),
            ).chain(CurveTween(curve: widget.reverseCurve)),
          );
          break;
        case StyledToastAnimationType.slideToLeftFade:
          slideToLeftAnimReverse = _reverseAnimController.drive(
            Tween<Offset>(
              begin: widget.reverseStartOffset ?? Offset.zero,
              end: widget.reverseEndOffset ?? const Offset(-1.0, 0.0),
            ).chain(CurveTween(curve: widget.reverseCurve)),
          );
          fadeAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: widget.reverseCurve,
            ),
          );
          break;
        case StyledToastAnimationType.slideToRight:
          slideToRightAnimReverse = _reverseAnimController.drive(
            Tween<Offset>(
              begin: widget.reverseStartOffset ?? Offset.zero,
              end: widget.reverseEndOffset ?? const Offset(1.0, 0.0),
            ).chain(CurveTween(curve: widget.reverseCurve)),
          );
          break;
        case StyledToastAnimationType.slideToRightFade:
          slideToRightAnimReverse = _reverseAnimController.drive(
            Tween<Offset>(
              begin: widget.reverseStartOffset ?? Offset.zero,
              end: widget.reverseEndOffset ?? const Offset(1.0, 0.0),
            ).chain(CurveTween(curve: widget.reverseCurve)),
          );
          fadeAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: widget.reverseCurve,
            ),
          );
          break;
        case StyledToastAnimationType.size:
          sizeAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: widget.reverseCurve,
              reverseCurve: widget.reverseCurve,
            ),
          );
          break;
        case StyledToastAnimationType.sizeFade:
          sizeAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: widget.reverseCurve,
              reverseCurve: widget.reverseCurve,
            ),
          );
          fadeAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: widget.reverseCurve,
              reverseCurve: widget.reverseCurve,
            ),
          );
          break;
        case StyledToastAnimationType.scale:
          scaleAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: widget.reverseCurve,
            ),
          );
          break;
        case StyledToastAnimationType.fadeScale:
          fadeAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: Interval(0.0, 1.0, curve: widget.reverseCurve),
            ),
          );
          scaleAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: Interval(0.0, 1.0, curve: widget.reverseCurve),
            ),
          );
          break;
        case StyledToastAnimationType.rotate:
          rotateAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: widget.reverseCurve,
            ),
          );
          break;
        case StyledToastAnimationType.scaleRotate:
          scaleAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: Interval(0.0, 1.0, curve: widget.reverseCurve),
            ),
          );
          rotateAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: Interval(0.0, 1.0, curve: widget.reverseCurve),
            ),
          );
          break;
        case StyledToastAnimationType.fadeRotate:
          fadeAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: Interval(0.0, 1.0, curve: widget.reverseCurve),
            ),
          );
          rotateAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: Interval(0.0, 1.0, curve: widget.reverseCurve),
            ),
          );
          break;
        case StyledToastAnimationType.none:
          break;
        default:
          fadeAnimReverse = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _reverseAnimController,
              curve: widget.reverseCurve,
            ),
          );
          break;
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Widget w = widget.child;

    if (widget.animationBuilder != null) {
      w = widget.animationBuilder!.call(context, _animationController, widget.duration, w);
    } else {
      w = createAnimWidget(w);
    }

    if (widget.reverseAnimBuilder != null) {
      w = widget.reverseAnimBuilder!.call(context, _reverseAnimController, widget.duration, w);
    } else {
      w = createReverseAnimWidget(w);
    }

    w = Opacity(
      opacity: opacity,
      child: w,
    );

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    w = Container(
      padding: EdgeInsets.only(bottom: mediaQueryData.padding.bottom, top: mediaQueryData.padding.top),
      alignment: positionAlignment,
      child: w,
    );

    if (Alignment.center == positionAlignment) {
    } else if (Alignment.bottomCenter == positionAlignment) {
      w = Padding(
        padding: EdgeInsets.only(bottom: offset!),
        child: w,
      );
    } else if (Alignment.topCenter == positionAlignment) {
      w = Padding(
        padding: EdgeInsets.only(top: offset!),
        child: w,
      );
    } else if (Alignment.topLeft == positionAlignment) {
      w = Padding(
        padding: EdgeInsets.only(top: offset!),
        child: w,
      );
    } else if (Alignment.topRight == positionAlignment) {
      w = Padding(
        padding: EdgeInsets.only(top: offset!),
        child: w,
      );
    } else if (Alignment.centerLeft == positionAlignment) {
      w = Padding(
        padding: EdgeInsets.only(left: offset!),
        child: w,
      );
    } else if (Alignment.centerRight == positionAlignment) {
      w = Padding(
        padding: EdgeInsets.only(right: offset!),
        child: w,
      );
    } else if (Alignment.bottomLeft == positionAlignment) {
      w = Padding(
        padding: EdgeInsets.only(bottom: offset!),
        child: w,
      );
    } else if (Alignment.bottomRight == positionAlignment) {
      w = Padding(
        padding: EdgeInsets.only(bottom: offset!),
        child: w,
      );
    } else {
      w = Padding(
        padding: EdgeInsets.all(offset!),
        child: w,
      );
    }

    return w;
  }

  /// Create animation widget for [w].
  Widget createAnimWidget(Widget w) {
    switch (widget.animation) {
      case StyledToastAnimationType.fade:
        w = FadeTransition(
          opacity: fadeAnim,
          child: w,
        );
        break;
      case StyledToastAnimationType.slideFromTop:
        w = SlideTransition(
          position: slideFromTopAnim,
          child: w,
        );
        break;
      case StyledToastAnimationType.slideFromTopFade:
        w = SlideTransition(
          position: slideFromTopAnim,
          child: FadeTransition(
            opacity: fadeAnim,
            child: w,
          ),
        );
        break;
      case StyledToastAnimationType.slideFromBottom:
        w = SlideTransition(
          position: slideFromBottomAnim,
          child: w,
        );
        break;
      case StyledToastAnimationType.slideFromBottomFade:
        w = SlideTransition(
          position: slideFromBottomAnim,
          child: FadeTransition(
            opacity: fadeAnim,
            child: w,
          ),
        );
        break;
      case StyledToastAnimationType.slideFromLeft:
        w = SlideTransition(
          position: slideFromLeftAnim,
          child: w,
        );
        break;
      case StyledToastAnimationType.slideFromLeftFade:
        w = SlideTransition(
          position: slideFromLeftAnim,
          child: FadeTransition(
            opacity: fadeAnim,
            child: w,
          ),
        );
        break;
      case StyledToastAnimationType.slideFromRight:
        w = SlideTransition(
          position: slideFromRightAnim,
          child: w,
        );
        break;
      case StyledToastAnimationType.slideFromRightFade:
        w = SlideTransition(
          position: slideFromRightAnim,
          child: FadeTransition(
            opacity: fadeAnim,
            child: w,
          ),
        );
        break;
      case StyledToastAnimationType.size:
        w = StyledToastAnimation(
          sizeFactor: sizeAnim,
          alignment: positionAlignment ?? Alignment.center,
          axisAlignment: 0.0,
          axis: widget.axis ?? Axis.horizontal,
          child: w,
        );
        break;
      case StyledToastAnimationType.sizeFade:
        w = StyledToastAnimation(
          sizeFactor: sizeAnim,
          axisAlignment: 0.0,
          alignment: positionAlignment ?? Alignment.center,
          axis: widget.axis ?? Axis.horizontal,
          child: FadeTransition(
            opacity: fadeAnim,
            child: w,
          ),
        );
        break;
      case StyledToastAnimationType.scale:
        w = ScaleTransition(
          scale: scaleAnim,
          alignment: widget.alignment ?? Alignment.center,
          child: w,
        );
        break;
      case StyledToastAnimationType.fadeScale:
        w = FadeTransition(
          opacity: fadeAnim,
          child: ScaleTransition(
            scale: scaleAnim,
            alignment: widget.alignment ?? Alignment.center,
            child: w,
          ),
        );
        break;
      case StyledToastAnimationType.rotate:
        w = RotationTransition(
          turns: rotateAnim,
          alignment: widget.alignment ?? FractionalOffset.center,
          child: w,
        );
        break;
      case StyledToastAnimationType.fadeRotate:
        w = FadeTransition(
          opacity: fadeAnim,
          child: RotationTransition(
            turns: rotateAnim,
            alignment: widget.alignment ?? FractionalOffset.center,
            child: w,
          ),
        );
        break;
      case StyledToastAnimationType.scaleRotate:
        w = ScaleTransition(
          scale: scaleAnim,
          alignment: widget.alignment ?? Alignment.center,
          child: RotationTransition(
            turns: rotateAnim,
            alignment: widget.alignment ?? FractionalOffset.center,
            child: w,
          ),
        );
        break;
      case StyledToastAnimationType.none:
        w = Container(
          child: w,
        );
        break;
      default:
        w = FadeTransition(
          opacity: fadeAnim,
          child: w,
        );
        break;
    }
    return w;
  }

  /// Create reverse animation widget for [w].
  Widget createReverseAnimWidget(Widget w) {
    if (widget.reverseAnimation != null && widget.animation != widget.reverseAnimation) {
      switch (widget.reverseAnimation) {
        case StyledToastAnimationType.fade:
          w = FadeTransition(
            opacity: fadeAnimReverse,
            child: w,
          );
          break;
        case StyledToastAnimationType.slideToTop:
          w = SlideTransition(
            position: slideToTopAnimReverse,
            child: w,
          );
          break;
        case StyledToastAnimationType.slideToTopFade:
          w = SlideTransition(
            position: slideToTopAnimReverse,
            child: FadeTransition(
              opacity: fadeAnimReverse,
              child: w,
            ),
          );
          break;
        case StyledToastAnimationType.slideToBottom:
          w = SlideTransition(
            position: slideToBottomAnimReverse,
            child: w,
          );
          break;
        case StyledToastAnimationType.slideToBottomFade:
          w = SlideTransition(
            position: slideToBottomAnimReverse,
            child: FadeTransition(
              opacity: fadeAnimReverse,
              child: w,
            ),
          );
          break;
        case StyledToastAnimationType.slideToLeft:
          w = SlideTransition(
            position: slideToLeftAnimReverse,
            child: w,
          );
          break;
        case StyledToastAnimationType.slideToLeftFade:
          w = SlideTransition(
            position: slideToLeftAnimReverse,
            child: FadeTransition(
              opacity: fadeAnimReverse,
              child: w,
            ),
          );
          break;
        case StyledToastAnimationType.slideToRight:
          w = SlideTransition(
            position: slideToRightAnimReverse,
            child: w,
          );
          break;
        case StyledToastAnimationType.slideToRightFade:
          w = SlideTransition(
            position: slideToRightAnimReverse,
            child: FadeTransition(
              opacity: fadeAnimReverse,
              child: w,
            ),
          );
          break;
        case StyledToastAnimationType.size:
          w = StyledToastAnimation(
            alignment: positionAlignment ?? Alignment.center,
            axis: widget.axis ?? Axis.horizontal,
            sizeFactor: sizeAnimReverse,
            child: w,
          );
          break;
        case StyledToastAnimationType.sizeFade:
          w = FadeTransition(
            opacity: fadeAnimReverse,
            child: StyledToastAnimation(
              alignment: positionAlignment ?? Alignment.center,
              axis: widget.axis ?? Axis.horizontal,
              sizeFactor: sizeAnimReverse,
              child: w,
            ),
          );
          break;
        case StyledToastAnimationType.scale:
          w = ScaleTransition(
            scale: scaleAnimReverse,
            alignment: widget.alignment ?? Alignment.center,
            child: w,
          );
          break;
        case StyledToastAnimationType.fadeScale:
          w = FadeTransition(
            opacity: fadeAnimReverse,
            child: ScaleTransition(
              scale: scaleAnimReverse,
              alignment: widget.alignment ?? Alignment.center,
              child: w,
            ),
          );
          break;
        case StyledToastAnimationType.rotate:
          w = RotationTransition(
            turns: rotateAnimReverse,
            alignment: widget.alignment ?? FractionalOffset.center,
            child: w,
          );
          break;
        case StyledToastAnimationType.fadeRotate:
          w = FadeTransition(
            opacity: fadeAnimReverse,
            child: RotationTransition(
              turns: rotateAnimReverse,
              alignment: widget.alignment ?? FractionalOffset.center,
              child: w,
            ),
          );
          break;
        case StyledToastAnimationType.scaleRotate:
          w = ScaleTransition(
            scale: scaleAnimReverse,
            child: RotationTransition(
              turns: rotateAnimReverse,
              alignment: widget.alignment ?? FractionalOffset.center,
              child: w,
            ),
          );
          break;
        case StyledToastAnimationType.none:
          break;
        default:
          break;
      }
    }
    return w;
  }

  /// Dismiss toast
  void dismissToast() {
    if (!mounted) {
      return;
    }
    _toastTimer?.cancel();
    setState(() {
      opacity = 0.0;
    });
  }

  /// Dismiss toast with animation.
  Future<void> dismissToastAnim({VoidCallback? onAnimationEnd}) async {
    if (!mounted) {
      return;
    }
    _toastTimer?.cancel();
    try {
      if (widget.animation != widget.reverseAnimation || widget.reverseAnimBuilder != null) {
        await _reverseAnimController.forward().orCancel;
      } else {
        await _animationController.reverse().orCancel;
      }
      onAnimationEnd?.call();
    } on TickerCanceled {
      onAnimationEnd?.call();
    }
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _reverseAnimController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) setState(() {});
  }
}
