import 'package:flutter/material.dart';
import '../constants/responsive_helper.dart';

/// A widget that builds different layouts based on screen size.
/// Useful for creating adaptive UIs that look good on all devices.
class ResponsiveBuilder extends StatelessWidget {
  /// Widget to display on mobile screens (< 600dp)
  final Widget mobile;

  /// Widget to display on tablet screens (600dp - 900dp)
  /// Falls back to [mobile] if not provided.
  final Widget? tablet;

  /// Widget to display on desktop/web screens (> 900dp)
  /// Falls back to [tablet] or [mobile] if not provided.
  final Widget? desktop;

  const ResponsiveBuilder({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveHelper.isDesktop(context)) {
          return desktop ?? tablet ?? mobile;
        } else if (ResponsiveHelper.isTablet(context)) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

/// A wrapper widget that constrains content width on larger screens
/// to prevent content from stretching too wide.
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? ResponsiveHelper.maxContentWidth(context),
          ),
          child: Padding(
            padding: padding ?? ResponsiveHelper.responsivePadding(context),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A grid that automatically adjusts column count based on screen size.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;

  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final columns = context.responsive(
      mobile: mobileColumns ?? 2,
      tablet: tabletColumns ?? 3,
      desktop: desktopColumns ?? 4,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: 1,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Responsive spacing widget that adapts to screen size.
class ResponsiveSpacing extends StatelessWidget {
  final double mobileHeight;
  final double? tabletHeight;
  final double? desktopHeight;

  const ResponsiveSpacing({
    Key? key,
    required this.mobileHeight,
    this.tabletHeight,
    this.desktopHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = context.responsive(
      mobile: mobileHeight,
      tablet: tabletHeight,
      desktop: desktopHeight,
    );
    return SizedBox(height: height);
  }
}
