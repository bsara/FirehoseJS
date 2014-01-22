class FirehoseJS.FacebookInteraction extends FirehoseJS.Interaction
  
  
  @firehoseType: "FacebookInteraction"
  
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
  
    
  @_facebookInteractionWithID: (id) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.FacebookInteraction,
      id: id
  
  
  _populateWithJSON: (json) ->
    if json.facebook_interaction?
      facebookJSON  = json.facebook_interaction
      this.setIfNotNull "fromUserId", facebookJSON.from_user_id
      this.setIfNotNull "fromName",   facebookJSON.from_name
      this.setIfNotNull "toUserId",   facebookJSON.to_user_id
      this.setIfNotNull "toName",     facebookJSON.to_name
      this.setIfNotNull "postId",     facebookJSON.post_id
      this.setIfNotNull "commentId",  facebookJSON.comment_id
      this.setIfNotNull "postType",   facebookJSON.post_type
      this.setIfNotNull "postExcerpt",facebookJSON.post_excerpt
      this.setIfNotNull "likeCount",  facebookJSON.like_count
    super json
  