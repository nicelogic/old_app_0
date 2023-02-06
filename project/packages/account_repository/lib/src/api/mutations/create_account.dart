const createAccount = r'''

mutation createAccount($id: ID!, $info: String!){
	createAccount(id: $id, info: $info){
      id
    	info
  }     
}

''';
