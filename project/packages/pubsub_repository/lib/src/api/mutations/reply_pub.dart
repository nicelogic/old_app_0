const replyPub = r'''

mutation ReplyPublishMutation($replyPublishId: ID!, $replyPublishEvent: String!, $replyPublishInfo: String!, $replyPublishState: String!) {
  replyPublish(id: $replyPublishId, event: $replyPublishEvent, info: $replyPublishInfo, state: $replyPublishState) {
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
