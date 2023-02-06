import 'contact.dart';

class ContactUpdate {
  final Contact _contact;
  Contact get contact => _contact;
  final String _event;
  String get event => _event;

  const ContactUpdate({required Contact contact, required String event})
      : _contact = contact,
        _event = event;
}
