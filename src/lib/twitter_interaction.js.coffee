class FirehoseJS.TwitterInteraction extends FirehoseJS.Interaction
  
  
  favorited: false
  
  tweetId: null
  
  inReplyToScreenName: null
  
  inReplyToStatusId: null
  
  retweetCount: 0
  
  tweetSource: null
  
  toUserId: null
  
  toScreenName: null
  
  fromUserId: null
  
  
  @_twitterInteractionWithID: (id) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.TwitterInteraction,
      id: id
  
  
  _populateWithJSON: (json) ->
    if json.twitter_interaction?
      twitterJSON           = json.twitter_interaction
      @favorited            = twitterJSON.favorited
      @tweetId              = twitterJSON.tweet_id
      @inReplyToScreenName  = twitterJSON.in_reply_to_screen_name
      @inReplyToStatusId    = twitterJSON.in_reply_to_status_id
      @retweetCount         = twitterJSON.retweet_count
      @tweetSource          = twitterJSON.tweet_source
      @toUserId             = twitterJSON.to_user_id
      @toScreenName         = twitterJSON.twitter_account.screen_name
      @fromUserId           = twitterJSON.from_user_id
    super json
 