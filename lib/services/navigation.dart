import 'package:flutter/material.dart';

class NS {
  NS._();
  
  static Route _fadeIn(Widget pushNav) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => pushNav,
      transitionsBuilder: (context, animation, secondaryAnimation, page) {
        var begin = 0.0;
        var end = 1.0;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return FadeTransition(
          opacity: animation.drive(tween),
          child: page,
        );
      },
    );
  }

  static fadeIn(Widget pushNav) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => pushNav,
      transitionsBuilder: (context, animation, secondaryAnimation, page) {
        var begin = 0.0;
        var end = 1.0;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return FadeTransition(
          opacity: animation.drive(tween),
          child: page,
        );
      },
    );
  }

  static Route _fromLeft(Widget pushNav) {
    return PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return pushNav;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    });
  }

  static fromLeft(Widget pushNav) {
    return PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return pushNav;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    });
  }

  static pushDefault(BuildContext context, Widget pushNav) {
    Navigator.push(context,
      _fadeIn(pushNav),
    );
  }
  static pushReplacementDefault(BuildContext context, Widget pushNav) {
    Navigator.pushReplacement(context,
      _fadeIn(pushNav)
    );
  }
  static push(BuildContext context, Widget pushNav) {
    Navigator.push(context, _fromLeft(pushNav));
  }
  static pushReplacement(BuildContext context, Widget pushNav) {
    Navigator.pushReplacement(context, _fromLeft(pushNav));
  }
  static pushReplacementUntil(BuildContext context, Widget pushNav) {
    Navigator.pushAndRemoveUntil(context,
      _fromLeft(pushNav,),
      (route) => false,
    );
  }
  static pushBackReplacement(BuildContext context, Widget pushNav) {
    Navigator.pushReplacement(context, _fromLeft(pushNav),
    );
  }
  static pop(BuildContext context, {bool rootNavigator = false}) {
    Navigator.of(context, rootNavigator: rootNavigator).pop();
  }
}
