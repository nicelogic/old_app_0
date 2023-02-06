const getMessages = r'''

query Query($getMessagesChatId: String!) {
  getMessages(chatId: $getMessagesChatId) {
    _id
    members {
      _id
      name
    }
    messages {
      _id
      text
      sender {
        _id
        name
      }
      date
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
