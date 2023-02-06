import 'package:app/router/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/config/config.dart';
import 'package:app/feature/account/account.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_form.dart';
import 'package:image/image.dart' as p_image;
import 'package:object_storage_repository/object_storage_repository.dart';

class PersonProfilePage extends StatefulWidget {
  const PersonProfilePage({Key? key}) : super(key: key);

  @override
  _PersonProfilePageState createState() => _PersonProfilePageState();
}

class _PersonProfilePageState extends State<PersonProfilePage> {
  @override
  Widget build(BuildContext context) {
    final account = context.select((AccountBloc bloc) => bloc.state.account);
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          title: Text(Config.instance().personProfile),
        ),
        body: Column(children: [
          ProfileForm(
            profileName: Config.instance().avatar,
            profileWidget: CircleAvatar(
                backgroundImage: ExtendedImage.network(Config.instance()
                        .objectStorageUserAvatarUrl(account.id))
                    .image),
            // profileWidget: FadeInImage.memoryNetwork(
            //   placeholder:
            //       Uint8List.fromList(generateDefaultUserAvatar(account.id[0])),
            //   image: 'http://niceice.cn:9000/${account.id}/avatar.ng',
            // ),
            onTap: () async {
              final _picker = ImagePicker();
              final pickedImage = await _picker.pickImage(
                  source: ImageSource.gallery, maxHeight: 36, maxWidth: 36);
              if (pickedImage == null) {
                return;
              }
              final imageBytes = await pickedImage.readAsBytes();
              final decodeImage = p_image.decodeImage(imageBytes);
              final imageData = p_image.encodePng(decodeImage!);
              final imageDataStream = ByteStream.fromBytes(imageData);
              await context.read<ObjectStorageRepository>().uploadImage(
                    userId: account.id,
                    objectName: Config.instance().objectStorageUserAvatar,
                    data: imageDataStream,
                  );
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('头像修改成功')));
            },
          ),
          ProfileForm(
              profileName: Config.instance().userName,
              profileWidget: Text(account.name),
              onTap: () {
                context.router.push(EditPersonProfileRoute(
                    inputLabel: Config.instance().pleaseInputNewName,
                    accountJsonKey: kName));
              }),
          ProfileForm(
            profileName: Config.instance().id,
            profileWidget: Text(account.id),
            onTap: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text(Config.instance().idCanNotChange)));
            },
          ),
          ProfileForm(
            profileName: Config.instance().signature,
            profileWidget: Text(account.signature),
            onTap: () {
              context.router.push(EditPersonProfileRoute(
                  inputLabel: Config.instance().pleaseInputNewSignature,
                  accountJsonKey: kSignature));
            },
          )
        ]));
  }
}
