import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/provider/provider.dart';
import 'common/router/auth_grard.dart';
import 'common/router/router.gr.dart';
import 'global.dart';

void main() {
  Global.init().then((value) => runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AppState>.value(
              value: Global.appState,
            ),
          ],
          child: Consumer<AppState>(builder: (context, appState, _) {
            if (appState.isGrayFilter) {
              return ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.color),
                child: MainApp(),
              );
            } else {
              return MainApp();
            }
          }),
        ),
      ));
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jpr',
      debugShowCheckedModeBanner: false,
      builder: ExtendedNavigator<AppRouter>(
        initialRoute: Routes.indexPageRoute,
        router: AppRouter(),
        guards: [AuthGuard()],
      ),
    );
  }
}
