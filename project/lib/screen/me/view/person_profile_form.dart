import 'package:app/router/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/config/config.dart';
import 'package:app/feature/account/account.dart';

class PersonProfileForm extends StatefulWidget {
  const PersonProfileForm({Key? key}) : super(key: key);

  @override
  _PersonProfileFormState createState() => _PersonProfileFormState();
}

class _PersonProfileFormState extends State<PersonProfileForm> {
  @override
  Widget build(BuildContext context) {
    final account = context.select((AccountBloc bloc) => bloc.state.account);
    return InkWell(
        onTap: () {
          context.router.push(const PersonProfileRoute());
        },
        child: Container(
            padding: const EdgeInsets.fromLTRB(1, 30, 15, 20),
            color: Colors.white,
            child: Row(children: [
              const SizedBox(width: 20),
              CircleAvatar(
                radius: 32,
                backgroundImage: ExtendedImage.network(Config.instance()
                        .objectStorageUserAvatarUrl(account.id))
                    .image,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      account.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${Config.instance().id}：${account.id}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right)
            ])));
  }
}
