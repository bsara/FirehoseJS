class FirehoseJS.CustomerAccount extends FirehoseJS.Object
      
  
  customer: null
  
  username: null
  
  followingUs: null
  
  imageURL: null
  
  description: null
  
  followersCount: null
  
  channel: null
  
  
  @_customerAccountWithID: (id, customer) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.CustomerAccount,
      id:       id
      customer: customer
    
    
  _populateWithJSON: (json) ->
    @username       = json.username
    @followingUs    = json.following_us
    @imageURL       = json.image_url
    @description    = json.description
    @followersCount = json.followers_count
    @channel        = json.channel
    super json