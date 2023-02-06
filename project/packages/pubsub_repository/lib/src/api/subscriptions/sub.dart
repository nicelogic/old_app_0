const sub = r'''

subscription Subscription($publicationReceivedAccountId: ID!) {
  publicationReceived(accountId: $publicationReceivedAccountId) {
    _id
    accountId
    targetId
    event
    info
    state
  }
}

''';
