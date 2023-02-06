const getContact = r'''

query account($id: ID!) {
  account(id: $id) {
    id
    contact {
      id
    }
  }
}


''';
