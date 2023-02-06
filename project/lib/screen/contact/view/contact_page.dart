
import 'package:app/config/local_config.dart';
import 'package:app/feature/contact/contact.dart';
import 'package:app/router/router/router.gr.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/feature/account/account.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:pubsub_repository/pubsub_repository.dart';
import 'package:ice_widget/ice_widget.dart';
import 'package:auto_route/auto_route.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    final contactBloc = context.read<ContactsBloc>();
    final me = context.read<AccountBloc>().state.account;
    contactBloc.contact(id: me.id);
    final pubsubRepository = context.read<PubsubRepository>();
    pubsubRepository.getPublicationsAndNotify(
        accountId: me.id, event: kAddContactReq);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '通讯录',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
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
                    context
                        .router.push(const SearchContactRoute());
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
          ],
        ),
        body: BlocBuilder<ContactsBloc, ContactsState>(builder: (context, state) {
          return Column(children: [
            BlocBuilder<AddContactsBloc, AddContactsState>(
                builder: (context, state) {
              final newContactNum = state.accounts.length.toString();
              return InkWell(
                  onTap: () {
                    context
                        .router.push(const NewContactRequestRoute());
                  },
                  child: ItemCard(
                    label: '新的朋友',
                    iconData: Icons.person_add,
                    badgeValue: newContactNum,
                  ));
            }),
            Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.fromLTRB(1, 10, 15, 10),
                child: const Center(
                  child: Text('联系人'),
                )),
            Expanded(child: contactList(context, state.contacts.toList()))
          ]);
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
      onTap: () {
        context
            .router.push(ContactProfileRoute(contact: contact));
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    // radius: 30,
                    backgroundImage: ExtendedImage.network(Config.instance()
                            .objectStorageUserAvatarUrl(contact.id))
                        .image,
                    
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
