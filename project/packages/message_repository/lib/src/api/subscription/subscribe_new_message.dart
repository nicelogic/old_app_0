const subscribeNewMessage = r'''

subscription Subscription($newMessageReceivedAccountId: String!) {
  newMessageReceived(accountId: $newMessageReceivedAccountId) {
    _id
    message {
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
