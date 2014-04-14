class Firehose.TwitterInteraction extends Firehose.Interaction
  
  
  # @nodoc
  @_firehoseType: "TwitterInteraction"
  
  ###
  @property [TwitterAccount] 
  ###
  twitterAccount: null
  
  ###
  @property [boolean] 
  ###
  favorited: false
  
  ###
  @property [String] 
  ###
  tweetId: null
  
  ###
  @property [String] 
  ###
  inReplyToScreenName: null
  
  ###
  @property [String] 
  ###
  inReplyToStatusId: null
  
  ###
  @property [number] 
  ###
  retweetCount: 0
  
  ###
  @property [String] 
  ###
  tweetSource: null
  
  ###
  @property [String] 
  ###
  toUserId: null
  
  ###
  @property [String] 
  ###
  toScreenName: null
  
  ###
  @property [String] 
  ###
  fromUserId: null
  
  
  # @nodoc
  @_twitterInteractionWithID: (id) ->
    Firehose.Object._objectOfClassWithID Firehose.TwitterInteraction,
      id: id
  
  
  # @nodoc
  _populateWithJSON: (json) ->
    if json.twitter_interaction?
      twitterJSON = json.twitter_interaction
      this._setIfNotNull "favorited",           twitterJSON.favorited
      this._setIfNotNull "tweetId",             twitterJSON.tweet_id
      this._setIfNotNull "inReplyToScreenName", twitterJSON.in_reply_to_screen_name
      this._setIfNotNull "inReplyToStatusId",   twitterJSON.in_reply_to_status_id
      this._setIfNotNull "retweetCount",        twitterJSON.retweet_count
      this._setIfNotNull "tweetSource",         twitterJSON.tweet_source
      this._setIfNotNull "toUserId",            twitterJSON.to_user_id
      this._setIfNotNull "toScreenName",        twitterJSON.twitter_account.screen_name
      this._setIfNotNull "fromUserId",          twitterJSON.from_user_id
      
      this._populateAssociatedObjectWithJSON this, "twitterAccount", twitterJSON.twitter_account, (json) ->
        Firehose.TwitterAccount._twitterAccountWithID( json.id )

    super json
 