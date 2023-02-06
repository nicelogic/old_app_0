part of 'contact_bloc.dart';

@JsonSerializable(explicitToJson: true)
class ContactsState extends Equatable {
  final Set<Contact> _contacts;
  Set<Contact> get contacts => _contacts;
  final int _contactNum;
  int get contactNum => _contactNum;
  const ContactsState(Set<Contact> contacts, int contactNum)
      : _contacts = contacts,
        _contactNum = contactNum;

  @override
  List<Object> get props => [_contacts, _contactNum];

  ContactsState add(final Contact contact) {
    _contacts.add(contact);
    return ContactsState(_contacts, _contacts.length);
  }

  factory ContactsState.fromJson(Map<String, dynamic> json) {
    try {
      return _$ContactStateFromJson(json);
    } catch (err) {
      return const ContactsState(<Contact>{}, 0);
    }
  }
  Map<String, dynamic> toJson() => _$ContactStateToJson(this);
}
