// import 'package:app/feature/account/account.dart';
// import 'package:app/feature/authentication/authentication.dart';
// import 'package:app/feature/chat/chat.dart';
// import 'package:app/feature/contact/contact.dart';
// import 'package:app/feature/pubsub/pubsub_bloc.dart';
// import 'package:message_repository/message_repository.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:authentication_repository/authentication_repository.dart';
// import 'package:account_repository/account_repository.dart';
// import 'package:pubsub_repository/pubsub_repository.dart';
// import 'package:contacts_repository/contacts_repository.dart';

// class ChatRouterWrapperPage extends StatelessWidget {
//   const ChatRouterWrapperPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final _accountRepository = context.read<AccountRepository>();
//     final _pubsubRepository = context.read<PubsubRepository>();
//     final authenticationBloc =
//         AuthenticationBloc(context.read<AuthenticationRepository>());
//     final accountBloc = AccountBloc(
//         accountRepository: _accountRepository,
//         authenticationBloc: authenticationBloc);

//     final contactBloc = ContactBloc(
//         accountRepository: _accountRepository,
//         contactRepository: context.read<ContactRepository>(),
//         pubsubRepository: _pubsubRepository,
//         accountBloc: accountBloc);
//     final pubsubBloc = PubsubBloc(
//         pubsubRepository: _pubsubRepository,
//         accountBloc: accountBloc,
//         contactBloc: contactBloc);
//     final addContactBloc = AddContactBloc(
//         accountRepository: _accountRepository,
//         pubsubRepository: _pubsubRepository,
//         accountBloc: accountBloc);
//     pubsubBloc.setAddContactBloc(addContactBloc);
//     final chatBloc = ChatBloc(
//         messageReposiotry: context.read<MessageRepository>(),
//         accountBloc: accountBloc);
//     return MultiBlocProvider(providers: [
//       BlocProvider<AuthenticationBloc>(
//           create: (BuildContext context) => authenticationBloc),
//       BlocProvider<AccountBloc>(create: (BuildContext context) => accountBloc),
//       BlocProvider<ContactBloc>(
//         create: (_) => contactBloc,
//       ),
//       BlocProvider<PubsubBloc>(
//         create: (BuildContext context) => pubsubBloc,
//         lazy: false,
//       ),
//       BlocProvider<AddContactBloc>(
//         create: (_) => addContactBloc,
//         lazy: false,
//       ),
//       BlocProvider<ChatBloc>(lazy: false, create: (_) => chatBloc),
//     ], child: const AutoRouter());
//   }
// }
