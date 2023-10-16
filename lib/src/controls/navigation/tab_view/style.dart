import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../../../../fluent_ui.dart';

// Alias to make it more clear
typedef TabStyle = ButtonStyle;

/// An inherited widget that defines the configuration for
/// [TabView]s in this widget's subtree.
///
/// Values specified here are used for [TabView] properties that are not
/// given an explicit non-null value.
class TabViewTheme extends InheritedTheme {
  /// Creates a [TabViewTheme] that controls the configurations for
  /// [TabView].
  const TabViewTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties for descendant [TabView] widgets.
  final TabViewThemeData data;

  /// Creates a tab view theme that controls how descendant [TabView]s
  /// should look like, and merges in the current theme, if any.
  static Widget merge({
    Key? key,
    required TabViewThemeData data,
    required Widget child,
  }) {
    return Builder(builder: (BuildContext context) {
      return TabViewTheme(
        key: key,
        data: _getInheritedThemeData(context).merge(data),
        child: child,
      );
    });
  }

  static TabViewThemeData _getInheritedThemeData(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<TabViewTheme>();
    return theme?.data ?? FluentTheme.of(context).tabViewTheme;
  }

  /// Returns the [data] from the closest [TabViewTheme] ancestor. If there is
  /// no ancestor, it returns [FluentThemeData.tabViewTheme]. Applications can assume
  /// that the returned value will not be null.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// TabViewThemeData theme = TabViewTheme.of(context);
  /// ```
  static TabViewThemeData of(BuildContext context) {
    return FluentTheme.of(context).tabViewTheme.merge(
          _getInheritedThemeData(context),
        );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return TabViewTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(TabViewTheme oldWidget) => data != oldWidget.data;
}

/// The theme data used by [TabView]. The default theme
/// data used is [TabViewThemeData.standard].
class TabViewThemeData with Diagnosticable {
  /// Generic
  final Duration? animationDuration;
  final Curve? animationCurve;
  final Brightness brightness;

  /// Tab styles
  final TabStyle? _tabStyle;
  TabStyle get tabStyle => _tabStyle ?? TabViewDefaults.getTabStyle(brightness);
  final ButtonStyle? _newTabButtonStyle;
  TabStyle get newTabButtonStyle =>
      _newTabButtonStyle ?? TabViewDefaults.getTabStyle(brightness);

  // Tab styles
  final BorderRadius tabBorderRadius;

  const TabViewThemeData({
    // Generic
    Brightness? brightness,
    this.animationDuration,
    this.animationCurve,
    // Tab styles
    TabStyle? tabStyle,
    ButtonStyle? newTabButtonStyle,
    BorderRadius? tabBorderRadius,
  })  : brightness = brightness ?? Brightness.light,
        _tabStyle = tabStyle,
        _newTabButtonStyle = newTabButtonStyle,
        tabBorderRadius = tabBorderRadius ??
            const BorderRadius.vertical(top: Radius.circular(6));

  factory TabViewThemeData.standard({
    // Generic
    required ResourceDictionary resources,
    required Duration animationDuration,
    required Curve animationCurve,
    required Typography typography,
    required Brightness brightness,
    // Tab styles
    TabStyle? tabStyle,
    ButtonStyle? newTabButtonStyle,
    BorderRadius? tabBorderRadius,
  }) {
    return TabViewThemeData(
      brightness: brightness,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      tabStyle: tabStyle,
      newTabButtonStyle: newTabButtonStyle,
      tabBorderRadius: tabBorderRadius,
    );
  }

  static TabViewThemeData lerp(
    TabViewThemeData? a,
    TabViewThemeData? b,
    double t,
  ) {
    return TabViewThemeData(
      brightness: t < 0.5 ? a?.brightness : b?.brightness,
      animationCurve: t < 0.5 ? a?.animationCurve : b?.animationCurve,
      animationDuration: lerpDuration(a?.animationDuration ?? Duration.zero,
          b?.animationDuration ?? Duration.zero, t),
      tabStyle:
          t < 0.5 ? a?.tabStyle : b?.tabStyle,
      newTabButtonStyle:
          t < 0.5 ? a?.newTabButtonStyle : b?.newTabButtonStyle,
      tabBorderRadius: t < 0.5 ? a?.tabBorderRadius : b?.tabBorderRadius,
    );
  }

  TabViewThemeData merge(TabViewThemeData? style) {
    return TabViewThemeData(
      brightness: style?.brightness ?? brightness,
      animationCurve: style?.animationCurve ?? animationCurve,
      animationDuration: style?.animationDuration ?? animationDuration,
      tabStyle: style?.tabStyle ?? tabStyle,
      newTabButtonStyle: style?.newTabButtonStyle ?? newTabButtonStyle,
      tabBorderRadius: style?.tabBorderRadius ?? tabBorderRadius,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('brightness', brightness))
      ..add(DiagnosticsProperty('tabStyle', tabStyle))
      ..add(DiagnosticsProperty('newTabButtonStyle', newTabButtonStyle))
      ..add(DiagnosticsProperty('tabBorderRadius', tabBorderRadius))
      ..add(
          DiagnosticsProperty<Duration>('animationDuration', animationDuration))
      ..add(DiagnosticsProperty<Curve>('animationCurve', animationCurve));
  }
}

class TabViewDefaults {
  TabViewDefaults._();
  static TabStyle getTabStyle(Brightness brightness) {
    final resources = (brightness == Brightness.light)
        ? const ResourceDictionary.light()
        : const ResourceDictionary.dark();

    return TabStyle(
      foregroundColor: ButtonState.resolveWith<Color>((states) {
        if (states.isSelected) {
          return resources.textFillColorPrimary;
        } else if (states.isPressing) {
          return resources.textFillColorSecondary;
        } else if (states.isHovering) {
          return resources.textFillColorPrimary;
        } else if (states.isDisabled) {
          return resources.textFillColorDisabled;
        } else {
          return resources.textFillColorSecondary;
        }
      }),
      backgroundColor: ButtonState.resolveWith<Color>((states) {
        if (states.isSelected) {
          return resources.layerOnMicaBaseAltFillColorSecondary;
        } else if (states.isPressing) {
          return resources.layerOnMicaBaseAltFillColorDefault;
        } else if (states.isHovering) {
          return resources.layerOnMicaBaseAltFillColorSecondary;
        } else if (states.isDisabled) {
          return resources.layerOnMicaBaseAltFillColorTransparent;
        } else {
          return resources.layerOnMicaBaseAltFillColorTransparent;
        }
      }),
    );
  }
}
