const pub = r'''

mutation PublishMutation($publishAccountId: ID!, $publishTargetId: ID!, $publishEvent: String!, $publishInfo: String!, $publishState: String!) {
  publish(accountId: $publishAccountId, targetId: $publishTargetId, event: $publishEvent, info: $publishInfo, state: $publishState) {
    _id
    accountId
    targetId
    event
    info
    state
    replyEvent
    replyInfo
  }
}

''';
