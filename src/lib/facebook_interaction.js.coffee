class FirehoseJS.FacebookInteraction extends FirehoseJS.Interaction
  
  
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
      this.set "fromUserId", facebookJSON.from_user_id
      this.set "fromName",   facebookJSON.from_name
      this.set "toUserId",   facebookJSON.to_user_id
      this.set "toName",     facebookJSON.to_name
      this.set "postId",     facebookJSON.post_id
      this.set "commentId",  facebookJSON.comment_id
      this.set "postType",   facebookJSON.post_type
      this.set "postExcerpt",facebookJSON.post_excerpt
      this.set "likeCount",  facebookJSON.like_count
    super json
  