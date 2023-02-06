import 'package:app/feature/chat/chat.dart';
import 'package:app/router/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:message_repository/message_repository.dart';
import 'package:ice_widget/ice_widget.dart';
import 'package:app/config/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/feature/account/account.dart';

class ContactProfilePage extends StatefulWidget {
  final Contact _contact;

  const ContactProfilePage({Key? key, required Contact contact})
      : _contact = contact,
        super(key: key);

  @override
  _ContactProfileState createState() => _ContactProfileState();
}

class _ContactProfileState extends State<ContactProfilePage> {
  @override
  Widget build(BuildContext context) {
    final accountId = context.read<AccountBloc>().state.account.id;
    return Scaffold(
        appBar: AppBar(
            leading: CloseButton(color: Theme.of(context).primaryColor),
            backgroundColor: Colors.white,
            elevation: 0),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(1, 10, 15, 20),
                  color: Colors.white,
                  child: Row(children: [
                    const SizedBox(width: 20),
                    CircleAvatar(
                      radius: 34,
                      backgroundImage:
                          Image.network(Config.instance()
                              .objectStorageUserAvatarUrl(widget._contact.id))
                          .image,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget._contact.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${Config.instance().id}：${widget._contact.id}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
              InkWell(
                  child: const LabelCard(
                    label: '\u{1F4AC} 发消息',
                  ),
                  onTap: () async {
                    final account = context.read<AccountBloc>().state.account;
                    final messageRepository = context.read<MessageRepository>();
                    final chat = await messageRepository.createChat(
                        accountId: account.id,
                        chatName: widget._contact.name,
                        memberIds: <String>{widget._contact.id});
                    context.router.push(MessageRoute(
                        currentUser: account,
                        chat: toChatWithMembers(
                            chat: chat, accountId: accountId)!, chatId: chat.id));
                  }),
              InkWell(
                  child: const LabelCard(
                    label: '\u{1F4F9} 音视频通话',
                  ),
                  onTap: () async {})
            ]));
  }
}
