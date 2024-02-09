import 'dart:async';

import 'package:flutter/widgets.dart';

import 'styled_toast.dart';

/// The method to dismiss all toast.
void dismissAllToast({bool showAnim = false}) {
  StyledToastManager().dismissAll(showAnim: showAnim);
}

/// The class for managing the overlay and dismiss.
///
/// Use the [dismiss] to dismiss toast.
/// When the Toast is dismissed, call [onDismiss] if specified.
class StyledToastFuture {
  /// Toast overlay.
  final OverlayEntry _entry;

  /// Callback when toast dismiss.
  final VoidCallback? _onDismiss;

  ///Toast widget key.
  final GlobalKey<StyledToastWidgetState> _containerKey;

  ///Is toast showing.
  bool _isShow = true;

  /// A [Timer] used to dismiss this toast future after the given period of time.
  Timer? _timer;

  /// Get the [_entry].
  OverlayEntry get entry => _entry;

  /// Get the [_onDismiss].
  VoidCallback? get onDismiss => _onDismiss;

  /// Get the [_isShow].
  bool get isShow => _isShow;

  /// Get the [_containerKey]
  GlobalKey get containerKey => _containerKey;

  StyledToastFuture.create(
    Duration duration,
    this._entry,
    this._onDismiss,
    this._containerKey,
  ) {
    if (duration != Duration.zero) {
      _timer = Timer(duration, () => dismiss());
    }
  }

  /// Dismiss toast overlay.
  ///
  /// [showAnim] Can be used to dismiss a toast with animation effect or not.
  Future<void> dismiss({
    bool showAnim = false,
  }) async {
    if (!_isShow) {
      return;
    }

    _isShow = false;
    _timer?.cancel();
    _onDismiss?.call();
    StyledToastManager().removeFuture(this);
    if (showAnim) {
      await _containerKey.currentState?.dismissToastAnim();
    } else {
      _containerKey.currentState?.dismissToast();
    }
    _entry.remove();
  }
}

/// Toast manager, manage toast list.
class StyledToastManager {
  StyledToastManager._();

  /// Instance of [StyledToastManager].
  static StyledToastManager? _instance;

  /// Factory to create [StyledToastManager] singleton.
  factory StyledToastManager() {
    _instance ??= StyledToastManager._();
    return _instance!;
  }

  /// [Set] used to save [StyledToastFuture].
  Set<StyledToastFuture> toastSet = {};

  /// Dismiss all toast.
  void dismissAll({
    bool showAnim = false,
  }) {
    toastSet.toList().forEach((v) {
      v.dismiss(showAnim: showAnim);
    });
  }

  /// Remove [StyledToastFuture].
  void removeFuture(StyledToastFuture future) {
    toastSet.remove(future);
  }

  /// Add [StyledToastFuture].
  void addFuture(StyledToastFuture future) {
    toastSet.add(future);
  }
}
