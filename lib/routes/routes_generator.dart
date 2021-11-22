import 'package:adhkar_flutter/ui/home/home_page.dart';
import 'package:adhkar_flutter/ui/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.SPLASH_SCREEN:
        return PageTransition(
            child: SplashScreen(), type: PageTransitionType.rightToLeft);

      case Routes.HOME_SCREEN:
        return PageTransition(
            child: HomeScreen(), type: PageTransitionType.rightToLeft);

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
