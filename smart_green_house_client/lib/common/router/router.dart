import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/material.dart';
import 'package:smart_green_house_client/pages/application/application.dart';
import 'package:smart_green_house_client/pages/index/index.dart';
import 'package:smart_green_house_client/pages/sign_in/sign_in.dart';
import 'package:smart_green_house_client/pages/sign_up/sign_up.dart';

import 'auth_grard.dart';

Widget zoomInTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  // you get an animation object and a widget
  // make your own transition
  return ScaleTransition(scale: animation, child: child);
}

@MaterialAutoRouter(generateNavigationHelperExtension: true)
class $AppRouter {
  @initial
  IndexPage indexPageRoute;

  SignInPage signInPageRoute;

  SignUpPage signUpPageRoute;

  @GuardedBy([AuthGuard])
  ApplicationPage applicationPageRoute;
}
