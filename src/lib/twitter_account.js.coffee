class FirehoseJS.TwitterAccount extends FirehoseJS.Object
  
  
  # @nodoc
  @_firehoseType: "TwitterAccount"
  
  company: null
  
  screenName: null
  
  twitterUserId: null
  
  imageURL: null
  
    
  # @nodoc
  @_twitterAccountWithID: (id, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.TwitterAccount,
      id:      id
      company: company
  
  
  @OAuthURLForCompanyWithCallback: (company, callback)  ->
    "#{FirehoseJS.rootFor('API')}/companies/#{company.id}/oauth_twitter?url_token=#{FirehoseJS.client.URLToken}&callback_url=#{encodeURIComponent(callback)}"
  
  
  destroy: ->
    params = 
      route: "twitter_accounts/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @company.twitterAccounts().dropObject this


  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "screenName",    json.screen_name
    this._setIfNotNull "twitterUserId", json.twitter_user_id
    this._setIfNotNull "imageURL",      json.image_url
    super json
