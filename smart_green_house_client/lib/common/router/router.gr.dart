// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:smart_green_house_client/pages/index/index.dart';
import 'package:smart_green_house_client/pages/sign_in/sign_in.dart';
import 'package:smart_green_house_client/pages/sign_up/sign_up.dart';
import 'package:smart_green_house_client/pages/application/application.dart';
import 'package:smart_green_house_client/common/router/auth_grard.dart';

abstract class Routes {
  static const indexPageRoute = '/';
  static const signInPageRoute = '/sign-in-page-route';
  static const signUpPageRoute = '/sign-up-page-route';
  static const applicationPageRoute = '/application-page-route';
  static const all = {
    indexPageRoute,
    signInPageRoute,
    signUpPageRoute,
    applicationPageRoute,
  };
}

class AppRouter extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;
  @override
  Map<String, List<Type>> get guardedRoutes => {
        Routes.applicationPageRoute: [AuthGuard],
      };
  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<AppRouter>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.indexPageRoute:
        if (hasInvalidArgs<IndexPageArguments>(args)) {
          return misTypedArgsRoute<IndexPageArguments>(args);
        }
        final typedArgs = args as IndexPageArguments ?? IndexPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => IndexPage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.signInPageRoute:
        if (hasInvalidArgs<SignInPageArguments>(args)) {
          return misTypedArgsRoute<SignInPageArguments>(args);
        }
        final typedArgs = args as SignInPageArguments ?? SignInPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => SignInPage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.signUpPageRoute:
        if (hasInvalidArgs<SignUpPageArguments>(args)) {
          return misTypedArgsRoute<SignUpPageArguments>(args);
        }
        final typedArgs = args as SignUpPageArguments ?? SignUpPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => SignUpPage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.applicationPageRoute:
        if (hasInvalidArgs<ApplicationPageArguments>(args)) {
          return misTypedArgsRoute<ApplicationPageArguments>(args);
        }
        final typedArgs =
            args as ApplicationPageArguments ?? ApplicationPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) =>
              ApplicationPage(key: typedArgs.key, idx: typedArgs.idx),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//IndexPage arguments holder class
class IndexPageArguments {
  final Key key;
  IndexPageArguments({this.key});
}

//SignInPage arguments holder class
class SignInPageArguments {
  final Key key;
  SignInPageArguments({this.key});
}

//SignUpPage arguments holder class
class SignUpPageArguments {
  final Key key;
  SignUpPageArguments({this.key});
}

//ApplicationPage arguments holder class
class ApplicationPageArguments {
  final Key key;
  final dynamic idx;
  ApplicationPageArguments({this.key, this.idx = 0});
}

// *************************************************************************
// Navigation helper methods extension
// **************************************************************************

extension AppRouterNavigationHelperMethods on ExtendedNavigatorState {
  Future pushIndexPageRoute({
    Key key,
  }) =>
      pushNamed(
        Routes.indexPageRoute,
        arguments: IndexPageArguments(key: key),
      );

  Future pushSignInPageRoute({
    Key key,
  }) =>
      pushNamed(
        Routes.signInPageRoute,
        arguments: SignInPageArguments(key: key),
      );

  Future pushSignUpPageRoute({
    Key key,
  }) =>
      pushNamed(
        Routes.signUpPageRoute,
        arguments: SignUpPageArguments(key: key),
      );

  Future pushApplicationPageRoute(
          {Key key, dynamic idx = 0, OnNavigationRejected onReject}) =>
      pushNamed(
        Routes.applicationPageRoute,
        arguments: ApplicationPageArguments(key: key, idx: idx),
        onReject: onReject,
      );
}
