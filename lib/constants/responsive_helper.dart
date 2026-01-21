import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Responsive design helper for handling different screen sizes.
/// Supports mobile, tablet, and desktop/web layouts.
class ResponsiveHelper {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Get the current screen width
  static double get screenWidth => Get.width;

  /// Get the current screen height
  static double get screenHeight => Get.height;

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if current screen is desktop/web
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  /// Get responsive value based on screen size
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  /// Width percentage - returns a percentage of screen width
  static double wp(double percentage) {
    return screenWidth * (percentage / 100);
  }

  /// Height percentage - returns a percentage of screen height
  static double hp(double percentage) {
    return screenHeight * (percentage / 100);
  }

  /// Responsive font size based on screen width
  static double responsiveFontSize(double baseFontSize) {
    if (screenWidth < 360) {
      return baseFontSize * 0.85;
    } else if (screenWidth < 400) {
      return baseFontSize * 0.95;
    } else if (screenWidth > 600) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  /// Get responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return EdgeInsets.symmetric(horizontal: wp(15), vertical: 24);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: wp(8), vertical: 20);
    }
    return EdgeInsets.symmetric(horizontal: wp(5), vertical: 16);
  }

  /// Get responsive horizontal padding value
  static double responsiveHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return wp(15);
    } else if (isTablet(context)) {
      return wp(8);
    }
    return wp(5);
  }

  /// Get number of grid columns based on screen size
  static int responsiveGridColumns(BuildContext context) {
    if (isDesktop(context)) {
      return 4;
    } else if (isTablet(context)) {
      return 3;
    }
    return 2;
  }

  /// Get responsive card width for grid items
  static double responsiveCardWidth(BuildContext context,
      {double spacing = 10}) {
    final columns = responsiveGridColumns(context);
    final padding = responsiveHorizontalPadding(context) * 2;
    final totalSpacing = spacing * (columns - 1);
    return (screenWidth - padding - totalSpacing) / columns;
  }

  /// Get max content width for centering on large screens
  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 1200;
    } else if (isTablet(context)) {
      return 800;
    }
    return screenWidth;
  }

  /// Wrap content with max width constraint for large screens
  static Widget constrainedContent({
    required BuildContext context,
    required Widget child,
    double? maxWidth,
  }) {
    final effectiveMaxWidth = maxWidth ?? maxContentWidth(context);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: child,
      ),
    );
  }
}

/// Extension on BuildContext for easier access
extension ResponsiveContext on BuildContext {
  bool get isMobile => ResponsiveHelper.isMobile(this);
  bool get isTablet => ResponsiveHelper.isTablet(this);
  bool get isDesktop => ResponsiveHelper.isDesktop(this);

  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) =>
      ResponsiveHelper.responsive(
        this,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );
}
