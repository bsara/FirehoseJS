class FirehoseJS.TwitterInteraction extends FirehoseJS.Interaction
  
  
  firehoseType: "TwitterInteraction"
  
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
      this.setIfNotNull "favorited",           twitterJSON.favorited
      this.setIfNotNull "tweetId",             twitterJSON.tweet_id
      this.setIfNotNull "inReplyToScreenName", twitterJSON.in_reply_to_screen_name
      this.setIfNotNull "inReplyToStatusId",   twitterJSON.in_reply_to_status_id
      this.setIfNotNull "retweetCount",        twitterJSON.retweet_count
      this.setIfNotNull "tweetSource",         twitterJSON.tweet_source
      this.setIfNotNull "toUserId",            twitterJSON.to_user_id
      this.setIfNotNull "toScreenName",        twitterJSON.twitter_account.screen_name
      this.setIfNotNull "fromUserId",          twitterJSON.from_user_id
    super json
 