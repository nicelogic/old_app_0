import 'package:app/feature/account/account.dart';
import 'package:app/feature/chat/chat.dart';
import 'package:app/feature/notification/notification.dart';
import 'package:app/router/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:app/config/config.dart';


class AppNavigationPage extends StatefulWidget {
  const AppNavigationPage({Key? key}) : super(key: key);

  @override
  _AppNavigationBarState createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
        routes: const [ChatRoute(), ContactRoute(), MeRoute()],
        bottomNavigationBuilder: (_, tabsRouter) {
          return BlocListener<LocalNotificationCubit, LocalNotificationState>(
              listenWhen: (previousState, state) {
                return state is LocalNewMessageNotification;
              },
              listener: (context, state) {
                final user = context.read<AccountBloc>().state.account;
                final newMessageNotification =
                    state as LocalNewMessageNotification;
                final chatId = newMessageNotification.chatId;
                final chats = context.read<ChatBloc>().state.chats;
                final chat = chats[chatId]!;
                final chatWithMembers =
                    toChatWithMembers(chat: chat, accountId: user.id);
                context.router.popUntilRoot();
                context.router.push(MessageRoute(
                    chatId: chatId, chat: chatWithMembers!, currentUser: user));
              },
              child: ConvexAppBar(
                backgroundColor: Theme.of(context).primaryColor,
                initialActiveIndex: tabsRouter.activeIndex,
                items: [
                  TabItem(
                      title: Config.instance().chatNavigation,
                      activeIcon: const Icon(
                        Icons.chat_bubble_outline,
                      ),
                      icon: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white60,
                      )),
                  TabItem(
                      title: Config.instance().contactNavigation,
                      activeIcon: const Icon(
                        Icons.contact_page_outlined,
                      ),
                      icon: const Icon(
                        Icons.contact_page_outlined,
                        color: Colors.white60,
                      )),
                  TabItem(
                      title: Config.instance().meNavigation,
                      activeIcon: const Icon(
                        Icons.person_outline,
                      ),
                      icon: const Icon(
                        Icons.person_outline,
                        color: Colors.white60,
                      ))
                ],
                onTap: (pageIndex) {
                  tabsRouter.setActiveIndex(pageIndex);
                },
              ));
        });
  }
}
