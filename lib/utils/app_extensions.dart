import 'package:flutter/material.dart';

extension WidgetPadding on Widget {
  Widget withPadding([EdgeInsets padding = const EdgeInsets.all(8)]) {
    return Padding(
      padding: padding,
      child: this,
    );
  }
}

extension WidgetMargin on Widget {
  Widget withMargin([EdgeInsets margin = const EdgeInsets.all(8)]) {
    return Container(
      margin: margin,
      child: this,
    );
  }
}

extension DateTimeFormatting on DateTime {
  String toFormattedString() {
    return "$day/$month/$year";
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

extension ClickableExtension on Widget {
  /// Adds tap and long press gestures to any widget
  Widget onClick({
    VoidCallback? onClick,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    bool showSplash = true,
    BorderRadius? borderRadius,
    Color? splashColor,
    HitTestBehavior? behavior,
    bool excludeFromSemantics = false,
  }) {
    return InkWell(
      onTap: onClick,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      borderRadius: borderRadius ?? BorderRadius.circular(0),
      splashColor: splashColor ?? Colors.black.withOpacity(0.1),
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      overlayColor: showSplash
          ? WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.pressed)) {
                return splashColor ?? Colors.black.withOpacity(0.1);
              }
              return null;
            })
          : null,
      excludeFromSemantics: excludeFromSemantics,
      child: this,
    );
  }
}
