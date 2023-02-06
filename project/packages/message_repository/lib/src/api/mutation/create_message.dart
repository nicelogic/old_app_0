const createMessage = r'''

mutation Mutation($createMessageAccountId: String!, $createMessageChatId: String!, $createMessageText: String!) {
  createMessage(accountId: $createMessageAccountId, chatId: $createMessageChatId, text: $createMessageText) {
    _id
    text
    date
    sender {
      _id
      name
    }
  }
}

''';
