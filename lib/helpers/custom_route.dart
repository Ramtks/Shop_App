import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(
            //: : is called "initializer list". It is a ,-separated list of expressions that can access constructor parameters and can assign to instance fields, even final instance fields. This is handy to initialize final fields with calculated values.The initializer list is also used to call other constructors like : ..., super('foo').
            builder: builder,
            settings:
                settings); //super is used to access the parent variables (MaterialPageRoute)

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation, //this one for single route transition
      Animation<double> secondaryAnimation,
      Widget child) {
    // TODO: implement buildTransitions
    // if (settings.name == '') {
    //   return child;
    // }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class CustompageTransitionsBuilder extends PageTransitionsBuilder {
  //this for general theme transition
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // if (route.settings.name == '/') {
    //   return child;
    // }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
