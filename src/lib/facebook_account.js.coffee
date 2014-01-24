class FirehoseJS.FacebookAccount extends FirehoseJS.Object
  
  
  # @nodoc
  @_firehoseType: "FacebookAccount"
  
  company: null
  
  username: null
  
  facebookUserId: null
  
  imageURL: null
  
  name: null
  
  # associations
  
  facebookPages: null
  
  
  # @nodoc
  _setup: ->
    @facebookPages = new FirehoseJS.UniqueArray
  
  
  # @nodoc
  @_facebookAccountWithID: (id, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.FacebookAccount,
      id:      id
      company: company
  
  
  @OAuthURLForCompanyWithCallback: (company, callback)  ->
    "#{FirehoseJS.rootFor('API')}/companies/#{company.id}/oauth_facebook?url_token=#{FirehoseJS.client.URLToken}&callback_url=#{encodeURIComponent(callback)}"
  
  
  destroy: ->
    params = 
      route: "facebook_accounts/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @company.facebookAccounts().dropObject this


  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "username",       json.username
    this._setIfNotNull "facebookUserId", json.facebook_user_id
    this._setIfNotNull "imageURL",       json.image_url
    this._setIfNotNull "name",           json.name
    
    this._populateAssociatedObjects this, "facebookPages", json.facebook_pages, (json) =>
      FirehoseJS.FacebookPage._facebookPageWithID( json.id, this )
      
    super json
    
  