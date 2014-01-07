class FirehoseJS.Agent extends FirehoseJS.Object
  
  
  @loggedInAgent: null
  
  accessToken: null
  
  URLToken: null
  
  firstName: null
  
  lastName: null
  
  email: null
  
  companies: new FirehoseJS.UniqueArray
  
  currentCompany: null
  
  _password: null

  
  constructor: (arg1, arg2) ->
    # with email and password
    if arg2?
      @email      = arg1
      @_password  = arg2
      
    # with id
    else if not isNaN(parseInt(arg1))
      @id = arg1
      
    # with access token
    else if typeof(arg1) == 'string'
      @accessToken = arg1

  
  signUpWithFirstAndLastName: (firstName, lastName) ->
    @firstName  = firstName
    @lastName   = lastName
    
    params = 
      route: 'agents'
      body:   
        agent:
          email:      @email 
          password:   @_password
          first_name: @firstName
          last_name:  @lastName
        
    FirehoseJS.client.post( params ).done (data) =>
      this._populateWithJSON data
      FirehoseJS.client.APIAccessToken = @accessToken
      FirehoseJS.Agent.loggedInAgent = this
  
  
  login: ->    
    params = 
      route: 'login'
      body:   
        email:    @email
        password: @_password
        
    FirehoseJS.client.post( params ).done (data) =>
      this._populateWithJSON data
      FirehoseJS.client.APIAccessToken = @accessToken
      FirehoseJS.Agent.loggedInAgent = this
    
    
  logout: ->
    @accessToken                          = null
    @URLToken                             = null
    FirehoseJS.Agent.loggedInAgent        = null
    FirehoseJS.client.APIAccessToken      = null
    FirehoseJS.client.URLToken            = null
    FirehoseJS.client.billingAccessToken  = null
    
  
  fetch: ->
    params = 
      route: "agents/#{@id}"
    FirehoseJS.client.get( params ).done (data) =>
      this._populateWithJSON data
      FirehoseJS.client.APIAccessToken = @accessToken
      FirehoseJS.Agent.loggedInAgent = this
      
  
  save: ->
    params = 
      route: "agents/#{@id}"
      body:  this._toJSON()
    FirehoseJS.client.put( params )
  
  
  destroy: ->
    params = 
      route: "agents/#{@id}"
    FirehoseJS.client.delete( params )
    
  
  dismissNotifications: (notifications) ->
    ids = []
    for notification in notifications
      ids.push notification.id
    
    params = 
      route: "agents/#{@id}/notifications/#{ids.join(',')}"
    FirehoseJS.client.put( params ).done ->
      for notification in notifications
        idx = notifications.indexOf notification
        notifications.splice( idx, 1 )
        
        
  @requestPasswordReset: (email) ->
    params = 
      route: "request_reset_password"
      body:
        email: email
    FirehoseJS.client.post( params )
    
  
  @resetPassword: (token, newPassword) ->
    params = 
      route: "reset_password"
      body:
        token:    token
        password: newPassword
    FirehoseJS.client.post( params )
    

  setNewPassword: (newPassword) ->
    @_password = newPassword


  fullName: ->
    "#{@firstName} #{@lastName}"
  
  
  _populateWithJSON: (json) ->
    @accessToken  ?= json.access_token
    @URLToken     ?= json.url_token
    @firstName    = json.first_name
    @lastName     = json.last_name
    @email        = json.email
    
    this._populateAssociatedObjects this, "companies", json.companies, (json) ->
      new FirehoseJS.Company( json.id, this )
      
    if @companies.length > 0 and not @currentCompany?
      @currentCompany = @companies[0]
    
    super json
    
    
  _toJSON: ->
    agent:
      first_name: @firstName
      last_name:  @lastName
      email:      @email
      password:   @_password if @_password?
      
      
