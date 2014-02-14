class Firehose.FacebookInteraction extends Firehose.Interaction
  
  
  # @nodoc
  @_firehoseType: "FacebookInteraction"
  
  ###
  @property [FacebookAccount] 
  ###
  facebookAccount: null
  
  ###
  @property [string] 
  ###
  fromUserId: null
  
  ###
  @property [string] 
  ###
  fromName: null
  
  ###
  @property [string] 
  ###
  toUserId: null
  
  ###
  @property [string] 
  ###
  toName: null
  
  ###
  @property [string] 
  ###
  postId: null
  
  ###
  @property [string] 
  ###
  commentId: null
  
  ###
  @property [string] either `post`, `comment` or `message`
  ###
  postType: null
  
  ###
  @property [string] 
  ###
  postExcerpt: null
  
  ###
  @property [integer] 
  ###
  likeCount: 0
  
    
  # @nodoc
  @_facebookInteractionWithID: (id) ->
    Firehose.Object._objectOfClassWithID Firehose.FacebookInteraction,
      id: id
  
  
  # @nodoc
  _populateWithJSON: (json) ->
    if json.facebook_interaction?
      facebookJSON  = json.facebook_interaction
      this._setIfNotNull "fromUserId", facebookJSON.from_user_id
      this._setIfNotNull "fromName",   facebookJSON.from_name
      this._setIfNotNull "toUserId",   facebookJSON.to_user_id
      this._setIfNotNull "toName",     facebookJSON.to_name
      this._setIfNotNull "postId",     facebookJSON.post_id
      this._setIfNotNull "commentId",  facebookJSON.comment_id
      this._setIfNotNull "postType",   facebookJSON.post_type
      this._setIfNotNull "postExcerpt",facebookJSON.post_excerpt
      this._setIfNotNull "likeCount",  facebookJSON.like_count
      
      this._populateAssociatedObjectWithJSON this, "facebookAccount", facebookJSON.facebook_account, (json) ->
        Firehose.FacebookAccount._facebookAccountWithID( json.id )
        
    super json
  