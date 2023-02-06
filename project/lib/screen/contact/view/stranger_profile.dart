import 'package:app/feature/contact/contact.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubsub_repository/pubsub_repository.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:ice_widget/ice_widget.dart';
import 'package:app/feature/account/bloc/account_bloc.dart';
import 'package:app/config/config.dart';

class StrangerProfilePage extends StatefulWidget {
  final Contact _contact;

  const StrangerProfilePage({Key? key, required Contact contact})
      : _contact = contact,
        super(key: key);

  @override
  _ContactProfileState createState() => _ContactProfileState();
}

class _ContactProfileState extends State<StrangerProfilePage> {
  @override
  Widget build(BuildContext context) {
    final account = context.select((AccountBloc bloc) => bloc.state.account);
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
                          ExtendedImage.network(Config.instance()
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
                    label: '添加到通讯录',
                  ),
                  onTap: () async {
                    String tapTip = '添加请求已发送,请等待对方同意';
                    try {
                      final pubsubRepository = context.read<PubsubRepository>();
                      await pubsubRepository.pub(
                          accountId: account.id,
                          targetId: widget._contact.id,
                          event: kAddContactReq,
                          info: '{}',
                          state: kPublicationStateCreate);
                    } catch (e) {
                      tapTip = e.toString();
                    }
                    ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(tapTip)));
                  }),
            ]));
  }
}
