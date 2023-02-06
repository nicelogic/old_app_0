
const signInWithUserName = r''' 

query signInWithUserName($input: UserNameInput!){
  signInWithUserName(input: $input){
    token,
    result
  }
}

''';
