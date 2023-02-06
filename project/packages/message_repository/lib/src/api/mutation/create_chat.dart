const createChat = r'''

mutation CreateChatMutation($createChatAccountId: String!, $createChatName: String!, $createChatMemberIds: [String!]!) {
  createChat(accountId: $createChatAccountId, name: $createChatName, memberIds: $createChatMemberIds) {
    _id
    members {
      _id
      name
    }
    name
    lastMessage {
      _id
      text
      sender {
        _id
        name
      }
      date
    }
  }
}

''';
