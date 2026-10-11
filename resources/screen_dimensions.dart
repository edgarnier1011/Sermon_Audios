import 'package:flutter/material.dart';

class ScreenDimensions {
  BuildContext? context;
  ScreenDimensions();

  MediaQueryData getDimensions(BuildContext context) {
    this.context = context;
    return MediaQuery.of(context);
  }
}
