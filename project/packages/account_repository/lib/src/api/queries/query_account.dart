const queryAccount = r'''

query queryAccount($idOrName: String!){
  queryAccount(idOrName: $idOrName){
    id,
    name,
    info
  }
}

''';


/*

{
  "idOrName": "1"		
}

*/
