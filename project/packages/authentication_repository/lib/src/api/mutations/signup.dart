const signUpWithUserName = r''' 

mutation signUpWithUserName($input: UserNameInput!){
  signUpWithUserName(input: $input){
    token,
    result
  }
}

''';

/*
{
  "input": {
    "userName": "ccccc",
    "password": "123"
  }
}
*/