import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubsub_repository/pubsub_repository.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:app/feature/account/account.dart';
import 'package:app/config/config.dart';
import 'package:app/feature/contact/contact.dart';

class NewContactRequestPage extends StatefulWidget {
  const NewContactRequestPage({Key? key}) : super(key: key);

  @override
  _NewContactRequestPageState createState() => _NewContactRequestPageState();
}

class _NewContactRequestPageState extends State<NewContactRequestPage> {
  @override
  Widget build(BuildContext context) {
    final me = context.read<AccountBloc>().state.account;
    final pubsubRepository = context.read<PubsubRepository>();
    final contactRepository = context.read<ContactsRepository>();
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          title: const Text('添加好友请求'),
        ),
        body: BlocBuilder<AddContactsBloc, AddContactsState>(
            builder: (context, state) {
          return ListView.builder(
              itemCount: state.accounts.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final account = state.accounts.entries.elementAt(index);
                return InkWell(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(1, 10, 15, 10),
                    child: Column(children: [
                      Row(
                        children: <Widget>[
                          const SizedBox(width: 20),
                          CircleAvatar(
                            radius: 34,
                            backgroundImage: ExtendedImage.network(Config.instance()
                                    .objectStorageUserAvatarUrl(
                                        account.value.id))
                                .image,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                Text(account.value.id,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      // fontWeight: FontWeight.w500
                                    )),
                                const SizedBox(height: 10),
                                Text('昵称： ${account.value.name}')
                              ])),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 15),
                            ),
                            onPressed: () async {
                              await contactRepository.updateContact(
                                  id: me.id,
                                  contactInput: ContactInput(
                                      event: kAddContact,
                                      id: account.value.id));
                              await pubsubRepository.pub(
                                  accountId: me.id,
                                  targetId: account.value.id,
                                  event: kAddContactAck,
                                  info: '{}',
                                  state: kPublicationStateCreate);
                              await pubsubRepository.replyPub(
                                  id: account.key,
                                  event: kAddContactAck,
                                  info: '{}',
                                  state: kPublicationStateClose);
                              context
                                  .read<AddContactsBloc>()
                                  .add(DelContacts(account.key));
                            },
                            child: const Text('同意'),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 15),
                            ),
                            onPressed: () async {
                              await pubsubRepository.replyPub(
                                  id: account.key,
                                  event: kAddContactNack,
                                  info: '{}',
                                  state: kPublicationStateClose);
                              context
                                  .read<AddContactsBloc>()
                                  .add(DelContacts(account.key));
                            },
                            child: const Text('拒绝'),
                          ),
                        ],
                      ),
                      if (index != (state.accounts.length - 1))
                        const Divider(
                          height: 20,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                    ]),
                  ),
                );
              });
        }));
  }
}
