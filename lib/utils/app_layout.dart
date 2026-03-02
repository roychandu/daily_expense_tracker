import 'dart:io';
import 'package:flutter/material.dart';

class AppLayout {
  const AppLayout._();

  static double horizontalPadding(BuildContext context) {
    if (Platform.isIOS) {
      return 20.0;
    }
    return 16.0;
  }

  static EdgeInsets screenPadding(BuildContext context) {
    final horizontal = horizontalPadding(context);
    return EdgeInsets.symmetric(horizontal: horizontal);
  }
}
