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
  
  
  constructor: (id) ->
    @id = id
  
  
  _populateWithJSON: (json) ->
    facebookJSON  = json.facebook_interaction
    @fromUserId   = facebookJSON.from_user_id
    @fromName     = facebookJSON.from_name
    @toUserId     = facebookJSON.to_user_id
    @toName       = facebookJSON.to_name
    @postId       = facebookJSON.post_id
    @commentId    = facebookJSON.comment_id
    @postType     = facebookJSON.post_type
    @postExcerpt  = facebookJSON.post_excerpt
    @likeCount    = facebookJSON.like_count
    super json
  