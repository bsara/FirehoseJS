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
      this.set "favorited",           twitterJSON.favorited
      this.set "tweetId",             twitterJSON.tweet_id
      this.set "inReplyToScreenName", twitterJSON.in_reply_to_screen_name
      this.set "inReplyToStatusId",   twitterJSON.in_reply_to_status_id
      this.set "retweetCount",        twitterJSON.retweet_count
      this.set "tweetSource",         twitterJSON.tweet_source
      this.set "toUserId",            twitterJSON.to_user_id
      this.set "toScreenName",        twitterJSON.twitter_account.screen_name
      this.set "fromUserId",          twitterJSON.from_user_id
    super json
 