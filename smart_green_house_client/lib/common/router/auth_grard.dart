import 'package:auto_route/auto_route.dart';
import 'package:smart_green_house_client/common/router/router.gr.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';

class AuthGuard extends RouteGuard {
  @override
  Future<bool> canNavigate(ExtendedNavigatorState navigator, String routeName,
      Object arguments) async {
    var isAuth = await isAuthenticated();
    if (isAuth == false) {
      ExtendedNavigator.rootNavigator.pushNamed(Routes.signInPageRoute);
    }

    return isAuth;
  }
}
