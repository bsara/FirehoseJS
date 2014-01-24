class FirehoseJS.CustomerAccount extends FirehoseJS.Object
  
  
  # @nodoc
  @_firehoseType: "CustomerAccount"
  
  customer: null
  
  username: null
  
  followingUs: null
  
  imageURL: null
  
  description: null
  
  followersCount: null
  
  channel: null
  
  
  # @nodoc
  @_customerAccountWithID: (id, customer) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.CustomerAccount,
      id:       id
      customer: customer
    
    
  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "username",       json.username
    this._setIfNotNull "followingUs",    json.following_us
    this._setIfNotNull "imageURL",       json.image_url
    this._setIfNotNull "description",    json.description
    this._setIfNotNull "followersCount", json.followers_count
    this._setIfNotNull "channel",        json.channel
    super json