const updateContact = r'''

mutation updateAccount($id: ID!, $info: String, $contactInput: ContactInput){
  updateAccount(id: $id, info: $info, contactInput: $contactInput){
      id
      contact{
        id
      }
  }
}

''';
