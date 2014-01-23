class FirehoseJS.TwitterAccount extends FirehoseJS.Object
  
  
  @firehoseType: "TwitterAccount"
  
  company: null
  
  screenName: null
  
  twitterUserId: null
  
  imageURL: null
  
    
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


  _populateWithJSON: (json) ->
    this.setIfNotNull "screenName",    json.screen_name
    this.setIfNotNull "twitterUserId", json.twitter_user_id
    this.setIfNotNull "imageURL",      json.image_url
    super json
