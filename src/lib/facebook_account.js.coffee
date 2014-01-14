class FirehoseJS.FacebookAccount extends FirehoseJS.Object
  
  
  company: null
  
  username: null
  
  facebookUserId: null
  
  imageURL: null
  
  name: null
  
  # associations
  
  facebookPages: new FirehoseJS.UniqueArray
  
  
  @_facebookAccountWithID: (id, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.FacebookAccount,
      id:      id
      company: company
  
  
  @OAuthURLForCompanyWithCallback: (company, callback)  ->
    "#{FirehoseJS.client.serverAddress()}/companies/#{company.id}/oauth_facebook?url_token=#{FirehoseJS.client.URLToken}&callback_url=#{callback}"
  
  
  destroy: ->
    params = 
      route: "facebook_accounts/#{@id}"
    FirehoseJS.client.delete( params )


  _populateWithJSON: (json) ->
    this.set "username",       json.username
    this.set "facebookUserId", json.facebook_user_id
    this.set "imageURL",       json.image_url
    this.set "name",           json.name
    
    this._populateAssociatedObjects this, "facebookPages", json.facebook_pages, (json) ->
      FirehoseJS.FacebookPage._facebookPageWithID( json.id, this )
      
    super json
    
  