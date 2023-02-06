// const getChats = r'''

// query Query($getChatsAccountId: String!) {
//   hello
//   getChats(accountId: $getChatsAccountId) {
//     _id
//     name
//     lastMessage {
//       _id
//       text
//       sender {
//         _id
//         name
//       }
//       date
//     }
//     members {
//       _id
//       name
//     }
//     messages {
//       _id
//       text
//       sender {
//         _id
//         name
//       }
//       date
//     }
//   }
// }

// ''';

const getChat = r'''

query Query($getChatChatId: String!) {
  getChat(chatId: $getChatChatId) {
    _id
    members {
      name
      _id
    }
    name
    lastMessage
  }
}

''';

const getChats = r'''

query Query($getChatsAccountId: String!) {
  hello
  getChats(accountId: $getChatsAccountId) {
    _id
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
    members {
      _id
      name
    }
  }
}

''';
