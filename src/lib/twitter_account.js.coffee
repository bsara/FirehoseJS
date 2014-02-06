class Firehose.TwitterAccount extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "TwitterAccount"
  
  company: null
  
  screenName: null
  
  twitterUserId: null
  
  imageURL: null
  
    
  # @nodoc
  @_twitterAccountWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.TwitterAccount,
      id:      id
      company: company
  
  
  @OAuthURLForCompanyWithCallback: (company, callback)  ->
    "#{Firehose.baseURLFor('API')}/companies/#{company.id}/oauth_twitter?url_token=#{Firehose.client.URLToken}&callback_url=#{encodeURIComponent(callback)}"
  
  
  destroy: ->
    params = 
      route: "twitter_accounts/#{@id}"
    Firehose.client.delete( params ).done =>
      @company.twitterAccounts().dropObject this


  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "screenName",    json.screen_name
    this._setIfNotNull "twitterUserId", json.twitter_user_id
    this._setIfNotNull "imageURL",      json.image_url
    super json
