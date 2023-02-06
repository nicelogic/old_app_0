import 'package:app/config/config.dart';
import 'package:app/feature/chat/chat.dart';
import 'package:app/router/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/feature/contact/contact.dart';
import 'package:app/feature/account/account.dart';
import 'package:message_repository/message_repository.dart';

class GroupContactPage extends StatefulWidget {
  const GroupContactPage({Key? key}) : super(key: key);

  @override
  State<GroupContactPage> createState() => _GroupContactPageState();
}

class _GroupContactPageState extends State<GroupContactPage> {
  final _selectedContacts = <Contact>[];

  @override
  Widget build(BuildContext context) {
    final account = context.read<AccountBloc>().state.account;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '设置群聊',
            style: TextStyle(color: Colors.white),
          ),
          leading: const BackButton(
            color: Colors.white,
          ),
          actions: [
            if (_selectedContacts.isNotEmpty)
              TextButton(
                  onPressed: () async {
                    final chat = await context
                        .read<MessageRepository>()
                        .createChat(
                            accountId: account.id,
                            chatName: '',
                            memberIds:
                                _selectedContacts.map((e) => e.id).toSet());
                    context.router.push(MessageRoute(
                      chatId: chat.id,
                        chat: toChatWithMembers(
                            chat: chat, accountId: account.id)!,
                        currentUser: account));
                  },
                  child: const Text('完成', style: TextStyle(color: Colors.white)))
          ],
        ),
        body: BlocBuilder<ContactsBloc, ContactsState>(
            bloc: context.read<ContactsBloc>(),
            builder: (context, state) {
              final contacts = state.contacts;
              contacts.removeWhere((element) => element.id == account.id);
              return contactList(context, contacts.toList());
            }));
  }

  Widget contactList(BuildContext context, List<Contact> contacts) {
    return ListView.separated(
      separatorBuilder: (_, index) => const Divider(indent: 60, height: 0),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: contacts.length,
      itemBuilder: (context, index) => contactItem(context, contacts[index]),
    );
  }

  Widget contactItem(BuildContext context, Contact contact) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: _selectedContacts.contains(contact),
                      onChanged: (isSelected) {
                        setState(() {
                          isSelected!
                              ? _selectedContacts.add(contact)
                              : _selectedContacts.remove(contact);
                        });
                      }),
                  const SizedBox(
                    width: 16,
                  ),
                  CircleAvatar(
                    backgroundImage: ExtendedImage.network(Config.instance()
                              .objectStorageUserAvatarUrl(contact.id))
                          .image,
                    maxRadius: 22,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            contact.name == '请填入昵称' ? contact.id : contact.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
