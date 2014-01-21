class FirehoseJS.CustomerAccount extends FirehoseJS.Object
  
  
  firehoseType: "CustomerAccount"
  
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
    this.setIfNotNull "username",       json.username
    this.setIfNotNull "followingUs",    json.following_us
    this.setIfNotNull "imageURL",       json.image_url
    this.setIfNotNull "description",    json.description
    this.setIfNotNull "followersCount", json.followers_count
    this.setIfNotNull "channel",        json.channel
    super json