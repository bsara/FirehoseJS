class FirehoseJS.TwitterAccount extends FirehoseJS.Object
  
  
  company: null
  
  screenName: null
  
  twitterUserId: null
  
  imageURL: null
  
  
  constructor: (id, company) ->
    @id       = id
    @company  = company
  
  
  @OAuthURLForCompanyWithCallback: (company, callback)  ->
    "#{FirehoseJS.client.serverAddress()}/companies/#{company.id}/oauth_twitter?url_token=#{FirehoseJS.client.URLToken}&callback_url=#{callback}"
  
  
  destroy: ->
    params = 
      route: "facebook_accounts/#{@id}"
    FirehoseJS.client.delete( params )


  _populateWithJSON: (json) ->
    @screenName     = json.screen_name
    @twitterUserId  = json.twitter_user_id
    @imageURL       = json.image_url
    super json
