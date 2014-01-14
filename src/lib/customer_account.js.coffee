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
    this.set "username",       json.username
    this.set "followingUs",    json.following_us
    this.set "imageURL",       json.image_url
    this.set "description",    json.description
    this.set "followersCount", json.followers_count
    this.set "channel",        json.channel
    super json