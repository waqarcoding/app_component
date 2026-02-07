import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class PageManager {
  static const _defaultDuration = Duration(milliseconds: 300);
  static const _defaultCurve = Curves.easeInOut;

  /// Fade In
  static void fadeIn<T extends Widget>(
    T Function() pageBuilder, {
    Duration duration = _defaultDuration,
    Curve curve = _defaultCurve,
  }) {
    Get.to(
      pageBuilder(),
      transition: Transition.fadeIn,
      duration: duration,
      curve: curve,
      opaque: true, // prevents background repaint
      fullscreenDialog: true, // reduces horizontal shift
    );
  }

  /// Zoom In (no slide)
  static void zoomIn<T extends Widget>(
    T Function() pageBuilder, {
    Duration duration = _defaultDuration,
    Curve curve = _defaultCurve,
  }) {
    Get.to(
      pageBuilder(),
      transition: Transition.topLevel,
      duration: duration,
      curve: curve,
      opaque: true, // prevents background repaint
      fullscreenDialog: true, // reduces horizontal shift
    );
  }

  /// Slide from Right (iOS-style)
  static void slideRight<T extends Widget>(
    T Function() pageBuilder, {
    Duration duration = _defaultDuration,
    Curve curve = _defaultCurve,
  }) {
    Get.to(
      pageBuilder(),
      transition: Transition.rightToLeft,
      duration: duration,
      curve: curve,
      opaque: true, // prevents background repaint
      fullscreenDialog: true, // reduces horizontal shift
    );
  }

  /// Slide from Left (back-like)
  static void slideLeft<T extends Widget>(
    T Function() pageBuilder, {
    Duration duration = _defaultDuration,
    Curve curve = _defaultCurve,
  }) {
    Get.to(
      pageBuilder(),
      transition: Transition.leftToRight,
      duration: duration,
      curve: curve,
      opaque: true, // prevents background repaint
      fullscreenDialog: true, // reduces horizontal shift
    );
  }

  /// Slide from Bottom (modal / sheet style)
  static void slideUp<T extends Widget>(
    T Function() pageBuilder, {
    Duration duration = _defaultDuration,
    Curve curve = _defaultCurve,
  }) {
    Get.to(
      pageBuilder(),
      transition: Transition.downToUp,
      duration: duration,
      curve: curve,
      opaque: true, // prevents background repaint
      fullscreenDialog: true, // reduces horizontal shift
    );
  }

  /// Replace current page
  static void off<T extends Widget>(
    T Function() pageBuilder, {
    Transition transition = Transition.fadeIn,
  }) {
    Get.off(
      pageBuilder(),
      transition: transition,
      duration: _defaultDuration,
      opaque: true, // prevents background repaint
      fullscreenDialog: true, // reduces horizontal shift
    );
  }

  /// Clear stack and go to page
  static void offAll<T extends Widget>(
    T Function() pageBuilder, {
    Transition transition = Transition.fadeIn,
  }) {
    Get.offAll(
      pageBuilder(),
      transition: transition,
      duration: _defaultDuration,
      opaque: true, // prevents background repaint
      fullscreenDialog: true, // reduces horizontal shift
    );
  }
}
