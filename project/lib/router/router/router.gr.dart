// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:account_repository/account_repository.dart' as _i13;
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:contacts_repository/contacts_repository.dart' as _i14;
import 'package:flutter/material.dart' as _i10;

import '../../feature/chat/chat.dart' as _i12;
import '../../screen/chat/chat.dart' as _i8;
import '../../screen/chat/message/message.dart' as _i2;
import '../../screen/contact/contact.dart' as _i3;
import '../../screen/contact/view/stranger_profile.dart' as _i4;
import '../../screen/login/login.dart' as _i7;
import '../../screen/me/me.dart' as _i5;
import '../../screen/navigation/navigation.dart' as _i1;
import '../../screen/video/video.dart' as _i6;
import 'auth_guard.dart' as _i11;

class AppRouter extends _i9.RootStackRouter {
  AppRouter(
      {_i10.GlobalKey<_i10.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i11.AuthGuard authGuard;

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    AppNavigationRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.AppNavigationPage());
    },
    MessageRoute.name: (routeData) {
      final args = routeData.argsAs<MessageRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.MessagePage(
              key: args.key,
              chatId: args.chatId,
              chat: args.chat,
              currentUser: args.currentUser));
    },
    NewContactRequestRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.NewContactRequestPage());
    },
    StrangerProfileRoute.name: (routeData) {
      final args = routeData.argsAs<StrangerProfileRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i4.StrangerProfilePage(key: args.key, contact: args.contact));
    },
    GroupContactRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.GroupContactPage());
    },
    SearchContactRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.SearchContactPage());
    },
    ContactProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ContactProfileRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.ContactProfilePage(key: args.key, contact: args.contact));
    },
    PersonProfileRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.PersonProfilePage());
    },
    EditPersonProfileRoute.name: (routeData) {
      final args = routeData.argsAs<EditPersonProfileRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.EditPersonProfilePage(
              key: args.key,
              inputLabel: args.inputLabel,
              accountJsonKey: args.accountJsonKey));
    },
    SettingsRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.SettingsPage());
    },
    VideoRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.VideoRouterWrapperPage());
    },
    LoginRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.LoginPage());
    },
    ChatRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i8.ChatPage());
    },
    ContactRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.ContactPage());
    },
    MeRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.MePage());
    },
    P2pVideoRoute.name: (routeData) {
      final args = routeData.argsAs<P2pVideoRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i6.P2pVideoPage(
              key: args.key,
              account: args.account,
              contactId: args.contactId,
              isCaller: args.isCaller));
    },
    RoomRoute.name: (routeData) {
      final args = routeData.argsAs<RoomRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i6.RoomPage(
              key: args.key, account: args.account, contacts: args.contacts));
    }
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(AppNavigationRoute.name, path: '/', guards: [
          authGuard
        ], children: [
          _i9.RouteConfig(ChatRoute.name,
              path: 'chat-page',
              parent: AppNavigationRoute.name,
              guards: [authGuard]),
          _i9.RouteConfig(ContactRoute.name,
              path: 'contact-page',
              parent: AppNavigationRoute.name,
              guards: [authGuard]),
          _i9.RouteConfig(MeRoute.name,
              path: 'me-page',
              parent: AppNavigationRoute.name,
              guards: [authGuard])
        ]),
        _i9.RouteConfig(MessageRoute.name, path: '/chat/:chatId'),
        _i9.RouteConfig(NewContactRequestRoute.name,
            path: '/new-contact-request-page'),
        _i9.RouteConfig(StrangerProfileRoute.name,
            path: '/stranger-profile-page'),
        _i9.RouteConfig(GroupContactRoute.name, path: '/group-contact-page'),
        _i9.RouteConfig(SearchContactRoute.name, path: '/search-contact-page'),
        _i9.RouteConfig(ContactProfileRoute.name,
            path: '/contact-profile-page'),
        _i9.RouteConfig(PersonProfileRoute.name, path: '/person-profile-page'),
        _i9.RouteConfig(EditPersonProfileRoute.name,
            path: '/edit-person-profile-page'),
        _i9.RouteConfig(SettingsRoute.name, path: '/settings-page'),
        _i9.RouteConfig(VideoRouter.name,
            path: '/video-router-wrapper-page',
            guards: [
              authGuard
            ],
            children: [
              _i9.RouteConfig(P2pVideoRoute.name,
                  path: 'p2p-video-page', parent: VideoRouter.name),
              _i9.RouteConfig(RoomRoute.name,
                  path: 'room-page', parent: VideoRouter.name)
            ]),
        _i9.RouteConfig(LoginRoute.name, path: '/login-page')
      ];
}

/// generated route for [_i1.AppNavigationPage]
class AppNavigationRoute extends _i9.PageRouteInfo<void> {
  const AppNavigationRoute({List<_i9.PageRouteInfo>? children})
      : super(name, path: '/', initialChildren: children);

  static const String name = 'AppNavigationRoute';
}

/// generated route for [_i2.MessagePage]
class MessageRoute extends _i9.PageRouteInfo<MessageRouteArgs> {
  MessageRoute(
      {_i10.Key? key,
      required String chatId,
      required _i12.ChatWithMembers chat,
      required _i13.Account currentUser})
      : super(name,
            path: '/chat/:chatId',
            args: MessageRouteArgs(
                key: key, chatId: chatId, chat: chat, currentUser: currentUser),
            rawPathParams: {'chatId': chatId});

  static const String name = 'MessageRoute';
}

class MessageRouteArgs {
  const MessageRouteArgs(
      {this.key,
      required this.chatId,
      required this.chat,
      required this.currentUser});

  final _i10.Key? key;

  final String chatId;

  final _i12.ChatWithMembers chat;

  final _i13.Account currentUser;
}

/// generated route for [_i3.NewContactRequestPage]
class NewContactRequestRoute extends _i9.PageRouteInfo<void> {
  const NewContactRequestRoute()
      : super(name, path: '/new-contact-request-page');

  static const String name = 'NewContactRequestRoute';
}

/// generated route for [_i4.StrangerProfilePage]
class StrangerProfileRoute extends _i9.PageRouteInfo<StrangerProfileRouteArgs> {
  StrangerProfileRoute({_i10.Key? key, required _i14.Contact contact})
      : super(name,
            path: '/stranger-profile-page',
            args: StrangerProfileRouteArgs(key: key, contact: contact));

  static const String name = 'StrangerProfileRoute';
}

class StrangerProfileRouteArgs {
  const StrangerProfileRouteArgs({this.key, required this.contact});

  final _i10.Key? key;

  final _i14.Contact contact;
}

/// generated route for [_i3.GroupContactPage]
class GroupContactRoute extends _i9.PageRouteInfo<void> {
  const GroupContactRoute() : super(name, path: '/group-contact-page');

  static const String name = 'GroupContactRoute';
}

/// generated route for [_i3.SearchContactPage]
class SearchContactRoute extends _i9.PageRouteInfo<void> {
  const SearchContactRoute() : super(name, path: '/search-contact-page');

  static const String name = 'SearchContactRoute';
}

/// generated route for [_i3.ContactProfilePage]
class ContactProfileRoute extends _i9.PageRouteInfo<ContactProfileRouteArgs> {
  ContactProfileRoute({_i10.Key? key, required _i14.Contact contact})
      : super(name,
            path: '/contact-profile-page',
            args: ContactProfileRouteArgs(key: key, contact: contact));

  static const String name = 'ContactProfileRoute';
}

class ContactProfileRouteArgs {
  const ContactProfileRouteArgs({this.key, required this.contact});

  final _i10.Key? key;

  final _i14.Contact contact;
}

/// generated route for [_i5.PersonProfilePage]
class PersonProfileRoute extends _i9.PageRouteInfo<void> {
  const PersonProfileRoute() : super(name, path: '/person-profile-page');

  static const String name = 'PersonProfileRoute';
}

/// generated route for [_i5.EditPersonProfilePage]
class EditPersonProfileRoute
    extends _i9.PageRouteInfo<EditPersonProfileRouteArgs> {
  EditPersonProfileRoute(
      {_i10.Key? key,
      required String inputLabel,
      required String accountJsonKey})
      : super(name,
            path: '/edit-person-profile-page',
            args: EditPersonProfileRouteArgs(
                key: key,
                inputLabel: inputLabel,
                accountJsonKey: accountJsonKey));

  static const String name = 'EditPersonProfileRoute';
}

class EditPersonProfileRouteArgs {
  const EditPersonProfileRouteArgs(
      {this.key, required this.inputLabel, required this.accountJsonKey});

  final _i10.Key? key;

  final String inputLabel;

  final String accountJsonKey;
}

/// generated route for [_i5.SettingsPage]
class SettingsRoute extends _i9.PageRouteInfo<void> {
  const SettingsRoute() : super(name, path: '/settings-page');

  static const String name = 'SettingsRoute';
}

/// generated route for [_i6.VideoRouterWrapperPage]
class VideoRouter extends _i9.PageRouteInfo<void> {
  const VideoRouter({List<_i9.PageRouteInfo>? children})
      : super(name,
            path: '/video-router-wrapper-page', initialChildren: children);

  static const String name = 'VideoRouter';
}

/// generated route for [_i7.LoginPage]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute() : super(name, path: '/login-page');

  static const String name = 'LoginRoute';
}

/// generated route for [_i8.ChatPage]
class ChatRoute extends _i9.PageRouteInfo<void> {
  const ChatRoute() : super(name, path: 'chat-page');

  static const String name = 'ChatRoute';
}

/// generated route for [_i3.ContactPage]
class ContactRoute extends _i9.PageRouteInfo<void> {
  const ContactRoute() : super(name, path: 'contact-page');

  static const String name = 'ContactRoute';
}

/// generated route for [_i5.MePage]
class MeRoute extends _i9.PageRouteInfo<void> {
  const MeRoute() : super(name, path: 'me-page');

  static const String name = 'MeRoute';
}

/// generated route for [_i6.P2pVideoPage]
class P2pVideoRoute extends _i9.PageRouteInfo<P2pVideoRouteArgs> {
  P2pVideoRoute(
      {_i10.Key? key,
      required _i13.Account account,
      required String contactId,
      bool? isCaller})
      : super(name,
            path: 'p2p-video-page',
            args: P2pVideoRouteArgs(
                key: key,
                account: account,
                contactId: contactId,
                isCaller: isCaller));

  static const String name = 'P2pVideoRoute';
}

class P2pVideoRouteArgs {
  const P2pVideoRouteArgs(
      {this.key,
      required this.account,
      required this.contactId,
      this.isCaller});

  final _i10.Key? key;

  final _i13.Account account;

  final String contactId;

  final bool? isCaller;
}

/// generated route for [_i6.RoomPage]
class RoomRoute extends _i9.PageRouteInfo<RoomRouteArgs> {
  RoomRoute(
      {_i10.Key? key,
      required _i13.Account account,
      required Set<_i14.Contact> contacts})
      : super(name,
            path: 'room-page',
            args:
                RoomRouteArgs(key: key, account: account, contacts: contacts));

  static const String name = 'RoomRoute';
}

class RoomRouteArgs {
  const RoomRouteArgs(
      {this.key, required this.account, required this.contacts});

  final _i10.Key? key;

  final _i13.Account account;

  final Set<_i14.Contact> contacts;
}
