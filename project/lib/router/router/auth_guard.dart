import 'package:auto_route/auto_route.dart';

var isAuthenticated = false;

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
      resolver.next(true);
    // if (!isAuthenticated) {
    //   //need to support when in some page but token became invalid
    //   if (router.navigatorKey.currentState != null) {
    //     router.popUntilRoot();
    //     router.push(const LoginRoute());
    //   }
    // } else {
    //   resolver.next(true);
    // }
  }
}
