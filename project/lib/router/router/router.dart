import 'package:app/screen/chat/chat.dart';
import 'package:app/screen/contact/contact.dart';
import 'package:app/screen/contact/view/stranger_profile.dart';
import 'package:app/screen/navigation/navigation.dart';
import 'package:auto_route/auto_route.dart';
import 'auth_guard.dart';

import 'package:app/screen/login/login.dart';
import 'package:app/screen/me/me.dart';
import 'package:app/screen/chat/message/message.dart';
import 'package:app/screen/video/video.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: AppNavigationPage, initial: true, guards: [
      AuthGuard
    ], children: [
      AutoRoute(
        page: ChatPage,
        guards: [AuthGuard],
      ),
      AutoRoute(
        page: ContactPage,
        guards: [AuthGuard],
      ),
      AutoRoute(page: MePage, guards: [AuthGuard]),
    ]),
    AutoRoute(page: MessagePage, path: '/chat/:chatId'),
    AutoRoute(page: NewContactRequestPage),
    AutoRoute(page: StrangerProfilePage),
    AutoRoute(page: GroupContactPage),
    AutoRoute(page: SearchContactPage),
    AutoRoute(page: ContactProfilePage),
    AutoRoute(page: PersonProfilePage),
    AutoRoute(page: EditPersonProfilePage),
    AutoRoute(page: SettingsPage),
    AutoRoute(
        name: 'VideoRouter',
        page: VideoRouterWrapperPage,
        guards: [AuthGuard],
        children: [AutoRoute(page: P2pVideoPage), AutoRoute(page: RoomPage)]),

    //login
    AutoRoute(page: LoginPage),
  ],
)
class $AppRouter {}

// class AppRouteInformationParser extends RouteInformationParser<RouterPage> {
//   @override
//   Future<RouterPage> parseRouteInformation(
//       RouteInformation routeInformation) async {
//     return SynchronousFuture(const RouterPage(page: AppNavigationPage()));
//   }

//   @override
//   RouteInformation restoreRouteInformation(RouterPage configuration) {
//     return const RouteInformation();
//   }
// }

// class AppRouterDelegate extends RouterDelegate<RouterPage>
//     with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouterPage> {
//   @override
//   final GlobalKey<NavigatorState> navigatorKey;
//   final _pathStack = <Widget>[];

//   AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<RouterCubit, RouterState>(
//         listener: (context, state) {
//           log('router cubit listen trigger');
//           state.emPageOperation == EmPageOperation.add
//               ? _pushPage(state.page)
//               : _removePage(_pathStack.first);
//         },
//         child: Navigator(onPopPage: _onPopPage, key: navigatorKey, pages: [
//           const RouterPage(page: AppNavigationPage()),
//           for (final routerPage in _pathStack) RouterPage(page: routerPage)
//         ]));
//   }

//   @override
//   Future<void> setNewRoutePath(RouterPage configuration) async {
//     navigatorKey.currentContext
//         ?.read<RouterCubit>()
//         .routePage(configuration.page);
//   }

//   void _pushPage(Widget newPage) {
//     _pathStack.add(newPage);
//     notifyListeners();
//   }

//   void _removePage(Widget page) {
//     _pathStack.remove(page);
//     notifyListeners();
//   }

//   bool _onPopPage(Route<dynamic> route, result) {
//     if (!route.didPop(result)) return false;
//     _removePage(_pathStack.first);
//     return true;
//   }
// }

// class NoAnimationTransitionDelegate extends TransitionDelegate<void> {
//   @override
//   Iterable<RouteTransitionRecord> resolve(
//       {List<RouteTransitionRecord> newPageRouteHistory = const [],
//       Map<RouteTransitionRecord?, RouteTransitionRecord>
//           locationToExitingPageRoute = const {},
//       Map<RouteTransitionRecord?, List<RouteTransitionRecord>>
//           pageRouteToPagelessRoutes = const {}}) {
//     final results = <RouteTransitionRecord>[];
//     for (final pageRoute in newPageRouteHistory) {
//       if (pageRoute.isWaitingForEnteringDecision) {
//         pageRoute.markForAdd();
//       }
//       results.add(pageRoute);
//     }

//     for (final exitingPageRoute in locationToExitingPageRoute.values) {
//       if (exitingPageRoute.isWaitingForExitingDecision) {
//         exitingPageRoute.markForRemove();
//         final pagelessRoutes = pageRouteToPagelessRoutes[exitingPageRoute];
//         if (pagelessRoutes != null) {
//           for (final pagelessRoute in pagelessRoutes) {
//             pagelessRoute.markForRemove();
//           }
//         }
//       }
//       results.add(exitingPageRoute);
//     }

//     return results;
//   }
// }
