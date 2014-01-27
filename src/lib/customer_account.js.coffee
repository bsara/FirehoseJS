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
      
      
  ###
  The customer account's avatar URL.
  @return [string] the url of the customer's avatar.
  ###
  avatarURL: ->
    # if an image url is present from facebook or twitter
    if this.imageURL
      return this.imageURL
    # if it's an email account, we try using gravatar
    if this.username.match /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
      e = this.username.trim().toLowerCase()
      hashedEmail = md5 e
    # otherwise, we just hash the username and use whatever pretty design gravatar generates from the hash.
    hashedEmail = md5 this.username unless hashedEmail
    "https://www.gravatar.com/avatar/#{hashedEmail}?d=identicon"
    
    
  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "username",       json.username
    this._setIfNotNull "followingUs",    json.following_us
    this._setIfNotNull "imageURL",       json.image_url
    this._setIfNotNull "description",    json.description
    this._setIfNotNull "followersCount", json.followers_count
    this._setIfNotNull "channel",        json.channel
    super json