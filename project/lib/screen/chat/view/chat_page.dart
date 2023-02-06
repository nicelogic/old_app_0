import 'dart:developer';

import 'package:app/config/config.dart';
import 'package:app/feature/account/account.dart';
import 'package:app/feature/chat/chat.dart';
import 'package:app/feature/notification/notification.dart';
import 'package:app/router/router/router.gr.dart';
import 'package:app/feature/message/message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_ui_kit/chat_ui_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  AppLifecycleState? _appLifecycleState;

  final ChatsListController _chatsController = ChatsListController();
  final _key = GlobalKey<_ChatPageState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    final account = context.read<AccountBloc>().state.account;
    final chatBloc = context.read<ChatBloc>();
    chatBloc.add(GetChatsEvent(account.id));
    log('send get chats event to chat bloc');
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              '聊天',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              if (kIsWeb)
                TextButton(
                    onPressed: () async {
                      await launch(Config.instance().lastVersionApkUrl);
                    },
                    child: const Text(
                      'app下载',
                      style: TextStyle(color: Colors.white),
                    )),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                ),
                onSelected: (String value) {
                  switch (value) {
                    case '发起群聊':
                      context.router.push(const GroupContactRoute());
                      break;
                    case '添加朋友':
                      context.router.push(const SearchContactRoute());
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'发起群聊', '添加朋友'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ]),
        body: BlocConsumer<ChatBloc, ChatState>(
            listenWhen: (previousState, state) {
          if (state.lastMessageWithChatIdForNotification == null) {
            return false;
          }
          final urlState = AutoRouterDelegate.of(context).urlState;
          final path = urlState.path;
          log('chat state change, current path: $path');
          var isInCurrentUserMessagePage = false;
          if (path.startsWith('/chat/')) {
            final currentRouteChatId =
                urlState.segments.first.pathParams.getString('chatId');
            final newMessageChatId =
                state.lastMessageWithChatIdForNotification!.id;
            isInCurrentUserMessagePage = currentRouteChatId == newMessageChatId;
          }
          return (path != '/' &&
                  path != '/chat-page' &&
                  !isInCurrentUserMessagePage) ||
              (_appLifecycleState != AppLifecycleState.resumed);
        }, listener: (context, state) {
          context.read<LocalNotificationCubit>().showNewMessageNotification(
              title: state
                  .lastMessageWithChatIdForNotification!.message.sender.name,
              body: state.lastMessageWithChatIdForNotification!.message.text,
              chatId: state.lastMessageWithChatIdForNotification!.id,
              senderAvatarUrl: Config.instance().objectStorageUserAvatarUrl(
                  state.lastMessageWithChatIdForNotification!.message.sender
                      .id));
        }, builder: (context, state) {
          ChatsControllerUtil.addChats(
              chatsController: _chatsController,
              chats: state.chats,
              accountId: account.id);
          return ChatsList(
            key: _key,
            appUserId: account.id,
            controller: _chatsController,
            builders: ChatsListTileBuilders(
                groupAvatarBuilder:
                    (context, imageIndex, itemIndex, size, item) {
                  final chat = item as ChatWithMembers;
                  return ExtendedImage.network(
                      chat.membersWithoutSelf[imageIndex].avatar,
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.cover);
                },
                lastMessageBuilder: _buildLastMessage,
                wrapper: _buildTileWrapper,
                dateBuilder: (context, date) => Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(DateFormatter.getVerboseDateTimeRepresentation(
                        context, date)))),
          );
        }));
  }

  Widget _buildLastMessage(BuildContext context, int index, ChatBase item) {
    final _chat = item as ChatWithMembers;
    //display avatar only if not a 1 to 1 conversation
    final bool displayAvatar = item.members.length >= 2;
    //display an icon if there's an attachment
    Widget? attachmentIcon;
    if (_chat.lastMessage!.hasAttachment) {
      final _type = _chat.lastMessage!.type;
      final iconColor = AppColors.chatsAttachmentIconColor(context);
      if (_type == ChatMessageType.audio) {
        attachmentIcon = Icon(Icons.keyboard_voice, color: iconColor);
      } else if (_type == ChatMessageType.video) {
        attachmentIcon = Icon(Icons.videocam, color: iconColor);
      } else if (_type == ChatMessageType.image) {
        attachmentIcon = Icon(Icons.image, color: iconColor);
      }
    }

    //get the message label
    String messageText = _chat.lastMessage!
        .messageText(context.read<AccountBloc>().state.account.id);

    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(children: [
          if (displayAvatar)
            Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ClipOval(
                    child: ExtendedImage.network(
                        item.lastMessage?.author?.avatar ??
                            Config.instance().objectStorageUserAvatarUrl(''),
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover))),
          if (attachmentIcon != null)
            Padding(
                padding: const EdgeInsets.only(right: 8),
                child: attachmentIcon),
          Expanded(
              child: Text(
            messageText,
            overflow: TextOverflow.ellipsis,
          ))
        ]));
  }

  void onItemPressed(ChatWithMembers chat) {
    //navigate to the chat
    final account = context.read<AccountBloc>().state.account;
    context.router
        .push(MessageRoute(chat: chat, currentUser: account, chatId: chat.id));
    //reset unread count
    if (chat.isUnread) {
      chat.chat!.unreadCount = 0;
    }
  }

  /// Called when the user long pressed an item (a chat)
  void onItemLongPressed(ChatBase chat) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(content: const Text("删除该聊天"), actions: [
            TextButton(
                onPressed: () {
                  context.popRoute();
                  // //delete in DB, from the current list in memory and update UI
                  // chatBloc.controller.removeItem(chat);
                },
                child: const Text("确认")),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: TextButton(
                  onPressed: () {
                    context.popRoute();
                  },
                  child: const Text("取消")),
            ),
          ]);
        });
  }

  Widget _buildTileWrapper(
      BuildContext context, int index, ChatBase item, Widget child) {
    return InkWell(
        onTap: () => onItemPressed(item as ChatWithMembers),
        onLongPress: () => onItemLongPressed(item),
        child: Column(children: [
          Padding(padding: const EdgeInsets.only(right: 16), child: child),
          Divider(
            height: 1.5,
            thickness: 1.5,
            color: AppColors.chatsSeparatorLineColor(context),
            //56 default GroupAvatar size + 32 padding
            indent: 56.0 + 32.0,
            endIndent: 16.0,
          )
        ]));
  }
}
