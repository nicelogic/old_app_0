const updateAccount = r'''

mutation updateAccount($id: ID!, $info: String, $contactInput: ContactInput){
  updateAccount(id: $id, info: $info, contactInput: $contactInput){
      id
      name
    	info
  }
}

''';
