import 'package:flutter/material.dart';

class CustomPageTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (route.settings.name == '/') {
      return child;
    } else {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
  }
}
