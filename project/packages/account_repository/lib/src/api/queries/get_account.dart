const getAccount = r''' 

query account($id: ID!) {
  account(id: $id) {
    id
    name
    info
  }
}

''';
