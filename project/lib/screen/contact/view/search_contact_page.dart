import 'package:app/config/config.dart';
import 'package:app/feature/account/account.dart';
import 'package:app/router/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:account_repository/account_repository.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:app/feature/contact/contact.dart';

class SearchContactPage extends StatefulWidget {
  const SearchContactPage({Key? key}) : super(key: key);

  @override
  _SearchContactPageState createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage> {
  @override
  Widget build(BuildContext context) {
    final accountRepository = context.read<AccountRepository>();
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return BlocProvider<SearchContactsBloc>(
        create: (BuildContext context) => SearchContactsBloc(
            accountRepository: accountRepository,
            accountBloc: context.read<AccountBloc>()),
        child: Scaffold(body:
            BlocBuilder<SearchContactsBloc, SearchContactsState>(
                builder: (context, state) {
          return FloatingSearchBar(
              leadingActions: const [Text(' \u{1F50D} ')],
              hint: 'id/昵称',
              scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
              transitionDuration: const Duration(milliseconds: 800),
              transitionCurve: Curves.easeInOut,
              physics: const BouncingScrollPhysics(),
              axisAlignment: isPortrait ? 0.0 : -1.0,
              openAxisAlignment: 0.0,
              width: isPortrait ? 600 : 500,
              debounceDelay: const Duration(milliseconds: 500),
              onQueryChanged: (query) {
                // Call your model, bloc, controller here.
                context
                    .read<SearchContactsBloc>()
                    .add(SearchContacts(key: query));
              },
              // Specify a custom transition to be used for
              // animating between opened and closed stated.
              transition: CircularFloatingSearchBarTransition(),
              actions: [
                // FloatingSearchBarAction(
                //   showIfOpened: false,
                //   child: CircularButton(
                //     icon: const Icon(Icons.cancel),
                //     onPressed: () {},
                //   ),
                // ),
                FloatingSearchBarAction.searchToClear(
                  showIfClosed: false,
                ),
              ],
              builder: (context, transition) {
                final searchContactResult =
                    context.watch<SearchContactsBloc>().state;
                final searchContacts = searchContactResult.searchContacts;
                final addedContacts =
                    context.read<ContactsBloc>().state.contacts;
                final contacts = searchContacts.difference(addedContacts);
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Material(
                    color: Colors.white,
                    elevation: 4.0,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      for (final contact in contacts)
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(1, 10, 15, 10),
                            child: Column(children: [
                              Row(children: <Widget>[
                                const SizedBox(width: 20),
                                CircleAvatar(
                                  radius: 34,
                                  backgroundImage: ExtendedImage.network(
                                          Config.instance()
                                              .objectStorageUserAvatarUrl(
                                                  contact.id))
                                      .image,
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                      Text(contact.id,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            // fontWeight: FontWeight.w500
                                          )),
                                      const SizedBox(height: 10),
                                      Text('昵称： ${contact.name}')
                                    ])),
                              ]),
                              if (contact != searchContacts.last)
                                const Divider(
                                  height: 20,
                                  thickness: 1,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                            ]),
                          ),
                          onTap: () => context.router.push(StrangerProfileRoute(
                            contact: contact,
                          )),
                        )
                    ]),
                  ),
                );
              });
        })));
  }
}
