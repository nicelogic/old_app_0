import 'dart:developer';

import 'package:app/config/config.dart';
import 'package:app/feature/chat/chat.dart';
import 'package:app/router/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:app/feature/message/message.dart';
import 'package:app/screen/chat/message/view/switch_appbar.dart';
import 'package:app/screen/chat/message/view/chat_message_image.dart';
import 'package:chat_ui_kit/chat_ui_kit.dart' hide ChatMessageImage;
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:account_repository/account_repository.dart';
import 'package:contacts_repository/contacts_repository.dart';

part 'message_page.gb.dart';

class MessagePage extends StatefulWidget {
  final ChatWithMembers chat;
  final Account currentUser;
  final String chatId;

  const MessagePage(
      {Key? key,
      @PathParam('chatId') required this.chatId,
      required this.chat,
      required this.currentUser})
      : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();

  /// The data controller
  final MessagesListController _controller = MessagesListController();

  /// Whether at least 1 message is selected
  int _selectedItemsCount = 0;

  /// Whether it's a group chat (more than 2 users)
  bool get _isGroupChat => widget.chat.members.length > 1;

  ChatWithMembers get _chat => widget.chat;

  ChatUser get _currentUser => ChatUser(
      id: widget.currentUser.id,
      name: widget.currentUser.name,
      avatarURL:
          Config.instance().objectStorageUserAvatarUrl(widget.currentUser.id));

  @override
  void initState() {
    _controller.selectionEventStream.listen((event) {
      setState(() {
        _selectedItemsCount = event.currentSelectionCount;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    messageBloc.add(GetMessagesEvent(chatId: widget.chat.id));
    return Scaffold(
        appBar: SwitchAppBar(
          showSwitch: _controller.isSelectionModeActive,
          switchLeadingCallback: () => _controller.unSelectAll(),
          primaryAppBar: AppBar(
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                context.router.popUntilRoot();
              },
            ),
            title: _buildChatTitle(),
            actions: [
              IconButton(
                onPressed: () {
                  if (_isGroupChat) {
                    context.router.push(RoomRoute(
                      account: widget.currentUser,
                      contacts:
                          widget.chat.members.map((e) => e.toContact()).toSet(),
                    ));
                  } else {
                    context.router.push(P2pVideoRoute(
                      account: widget.currentUser,
                      contactId: widget.chat.members[0].toContact().id,
                    ));
                  }
                },
                icon: const Icon(Icons.video_call_outlined),
                color: Colors.white,
              ),
              IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.more_horiz),
                  onPressed: onChatDetailsPressed)
            ],
          ),
          switchTitle: Text(_selectedItemsCount.toString(),
              style: const TextStyle(color: Colors.black)),
          switchActions: [
            IconButton(
                icon: const Icon(Icons.content_copy),
                color: Colors.black,
                onPressed: copyContent),
            IconButton(
                color: Colors.black,
                icon: const Icon(Icons.delete),
                onPressed: deleteSelectedMessages),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMessagesList(),
            MessageInput(
                textController: _textController,
                sendCallback: onMessageSend,
                typingCallback: onTypingEvent),
          ],
        ));
  }

  /// Called when the user pressed the top right corner icon
  void onChatDetailsPressed() {
    final firstMember = widget.chat.members.first;
    context.router.push(ContactProfileRoute(
        contact: Contact(id: firstMember.id, name: firstMember.name)));
  }

  /// Called when a user tapped an item
  void onItemPressed(int index, MessageBase message) {
    log("item pressed, you could display images in full screen or play videos with this callback");
  }

  void onMessageSend(String text) {
    final chatMessage = ChatMessage(
        author: _currentUser,
        text: text,
        creationTimestamp: DateTime.now().millisecondsSinceEpoch);
    context.read<MessageBloc>().add(NewSendMessageEvent(
        chatId: widget.chat.id, message: chatMessage.toMessage()));
  }

  void onTypingEvent(TypingEvent event) {
    log("typing event received: $event");
  }

  /// Copy the selected comment's comment to the clipboard.
  /// Reset selection once copied.
  void copyContent() {
    String text = "";
    for (var element in _controller.selectedItems) {
      text += element.text ?? "";
      text += '\n';
    }
    Clipboard.setData(ClipboardData(text: text)).then((value) {
      log("text selected");
      _controller.unSelectAll();
    });
  }

  void deleteSelectedMessages() {
    _controller.removeSelectedItems();
    //update app bar
    setState(() {});
  }

  Widget _buildChatTitle() {
    if (_isGroupChat) {
      return Text(
        _chat.name,
        style: const TextStyle(color: Colors.white),
      );
    } else {
      final _user = _chat.membersWithoutSelf.first;
      return Row(children: [
        ClipOval(
            child: ExtendedImage.network(_user.avatar,
                width: 32, height: 32, fit: BoxFit.cover)),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(_user.name, overflow: TextOverflow.ellipsis)))
      ]);
    }
  }

  Widget _buildMessageBody(
      context, index, item, messagePosition, MessageFlow messageFlow) {
    final _chatMessage = item as ChatMessage;
    Widget _child;

    if (_chatMessage.type == ChatMessageType.text) {
      _child = _ChatMessageText(index, item, messagePosition, messageFlow);
    } else if (_chatMessage.type == ChatMessageType.image) {
      _child = ChatMessageImage(index, item, messagePosition, messageFlow,
          callback: () => onItemPressed(index, item));
    } else if (_chatMessage.type == ChatMessageType.video) {
      _child = ChatMessageVideo(index, item, messagePosition, messageFlow);
    } else if (_chatMessage.type == ChatMessageType.audio) {
      _child = ChatMessageAudio(index, item, messagePosition, messageFlow);
    } else {
      //return text message as default
      _child = _ChatMessageText(index, item, messagePosition, messageFlow);
    }

    if (messageFlow == MessageFlow.incoming) return _child;
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Align(alignment: Alignment.centerRight, child: _child));
  }

  Widget _buildDate(BuildContext context, DateTime date) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Align(
                child: Text(
                    DateFormatter.getVerboseDateTimeRepresentation(
                        context, date),
                    style:
                        TextStyle(color: Theme.of(context).disabledColor)))));
  }

  Widget _buildEventMessage(context, animation, index, item, messagePosition) {
    final _chatMessage = item as ChatMessage;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Align(
                child: Text(
              _chatMessage.messageText(_currentUser.id),
              style: TextStyle(color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ))));
  }

  Widget _buildMessagesList() {
    IncomingMessageTileBuilders incomingBuilders = _isGroupChat
        ? IncomingMessageTileBuilders(
            bodyBuilder: (context, index, item, messagePosition) =>
                _buildMessageBody(context, index, item, messagePosition,
                    MessageFlow.incoming),
            avatarBuilder: (context, index, item, messagePosition) {
              final _chatMessage = item as ChatMessage;
              return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ClipOval(
                      child: ExtendedImage.network(_chatMessage.author!.avatar,
                          width: 32, height: 32, fit: BoxFit.cover)));
            })
        : IncomingMessageTileBuilders(
            bodyBuilder: (context, index, item, messagePosition) =>
                _buildMessageBody(context, index, item, messagePosition,
                    MessageFlow.incoming),
            titleBuilder: null);

    return Expanded(
        child: BlocBuilder<MessageBloc, MessageState>(
            bloc: context.read<MessageBloc>(),
            builder: (context, state) {
              if (state.chats[widget.chat.id] != null) {
                MessagesControllerUtil.addMessages(
                    messagesController: _controller,
                    messages: toMessages(state.chats[widget.chat.id]!),
                    chatId: widget.chat.id);
              }
              return MessagesList(
                  controller: _controller,
                  appUserId: _currentUser.id,
                  useCustomTile: (i, item, pos) {
                    final msg = item as ChatMessage;
                    return msg.isTypeEvent;
                  },
                  messagePosition: _messagePosition,
                  builders: MessageTileBuilders(
                      customTileBuilder: _buildEventMessage,
                      customDateBuilder: _buildDate,
                      incomingMessageBuilders: incomingBuilders,
                      outgoingMessageBuilders: OutgoingMessageTileBuilders(
                          bodyBuilder:
                              (context, index, item, messagePosition) =>
                                  _buildMessageBody(context, index, item,
                                      messagePosition, MessageFlow.outgoing))));
            }));
  }
}

/// Override [MessagePosition] to return [MessagePosition.isolated] when
/// our [ChatMessage] is an event
MessagePosition _messagePosition(
    MessageBase? previousItem,
    MessageBase currentItem,
    MessageBase? nextItem,
    bool Function(MessageBase currentItem) shouldBuildDate) {
  ChatMessage? _previousItem = previousItem as ChatMessage?;
  final ChatMessage _currentItem = currentItem as ChatMessage;
  ChatMessage? _nextItem = nextItem as ChatMessage?;

  if (shouldBuildDate(_currentItem)) {
    _previousItem = null;
  }

  if (_nextItem?.isTypeEvent == true) _nextItem = null;
  if (_previousItem?.isTypeEvent == true) _previousItem = null;

  if (_previousItem?.author?.id == _currentItem.author?.id &&
      _nextItem?.author?.id == _currentItem.author?.id) {
    return MessagePosition.surrounded;
  } else if (_previousItem?.author?.id == _currentItem.author?.id &&
      _nextItem?.author?.id != _currentItem.author?.id) {
    return MessagePosition.surroundedTop;
  } else if (_previousItem?.author?.id != _currentItem.author?.id &&
      _nextItem?.author?.id == _currentItem.author?.id) {
    return MessagePosition.surroundedBot;
  } else {
    return MessagePosition.isolated;
  }
}

///************************************************ Functional widgets used in the screen ***************************************

@swidget
Widget _chatMessageText(BuildContext context, int index, ChatMessage message,
    MessagePosition messagePosition, MessageFlow messageFlow) {
  return MessageContainer(
      decoration: messageDecoration(context,
          messagePosition: messagePosition, messageFlow: messageFlow),
      child: Wrap(runSpacing: 4.0, alignment: WrapAlignment.end, children: [
        Text(message.text ?? ""),
        ChatMessageFooter(index, message, messagePosition, messageFlow)
      ]));
}

@swidget
Widget chatMessageFooter(BuildContext context, int index, ChatMessage message,
    MessagePosition messagePosition, MessageFlow messageFlow) {
  final Widget _date = _ChatMessageDate(index, message, messagePosition);
  return messageFlow == MessageFlow.incoming
      ? _date
      : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
              _date,
            ]);
}

@swidget
Widget _chatMessageDate(BuildContext context, int index, ChatMessage message,
    MessagePosition messagePosition) {
  final color =
      message.isTypeMedia ? Colors.white : Theme.of(context).disabledColor;
  return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
          DateFormatter.getVerboseDateTimeRepresentation(
              context, message.createdAt,
              timeOnly: true),
          style: TextStyle(color: color)));
}
