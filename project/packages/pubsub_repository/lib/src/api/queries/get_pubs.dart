const getPubs = r'''

query Query($getPublicationsAccountId: ID!, $getPublicationsEvent: String!) {
  getPublications(accountId: $getPublicationsAccountId, event: $getPublicationsEvent) {
    _id
    accountId
    targetId
    event
    info
    state
  }
}

''';
