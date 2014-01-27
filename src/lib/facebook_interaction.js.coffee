class FirehoseJS.FacebookInteraction extends FirehoseJS.Interaction
  
  
  # @nodoc
  @_firehoseType: "FacebookInteraction"
  
  fromUserId: null
  
  fromName: null
  
  toUserId: null
  
  toName: null
  
  postId: null
  
  commentId: null
  
  postType: null
  
  postExcerpt: null
  
  likeCount: 0
  
  type: null
  
    
  # @nodoc
  @_facebookInteractionWithID: (id) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.FacebookInteraction,
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
        FirehoseJS.FacebookAccount._facebookAccountWithID( json.id )
        
    super json
  