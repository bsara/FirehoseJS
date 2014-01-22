class FirehoseJS.Agent extends FirehoseJS.Object
  
  
  @firehoseType: "Agent"
  
  @loggedInAgent: null
  
  accessToken: null
  
  URLToken: null
  
  firstName: null
  
  lastName: null
  
  email: null
  
  currentCompany: null
  
  _password: null
  
  # associations
  
  companies: null 
  
  
  setup: ->
    @companies = new FirehoseJS.UniqueArray


  @agentWithAccessToken: (accessToken) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Agent,
      accessToken: accessToken
      
      
  @agentWithEmailAndPassword: (email, password) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Agent,
      email:      email
      _password:  password
      

  @agentWithID: (id) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Agent,
      id: id
    
  
  signUpWithFirstAndLastName: (firstName, lastName) ->
    this.setIfNotNull "firstName", firstName
    this.setIfNotNull "lastName",  lastName
    
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
    FirehoseJS.client.APIAccessToken = null
    
    params = 
      route: 'login'
    
    if @email? and @_password?
      params.body =
        email:    @email      
        password: @_password  
    else if @accessToken?
      FirehoseJS.client.APIAccessToken = @accessToken
        
    FirehoseJS.client.post( params ).done (data) =>
      this._populateWithJSON data
      FirehoseJS.client.APIAccessToken  = @accessToken
      FirehoseJS.client.URLToken        = @URLToken
      FirehoseJS.Agent.loggedInAgent = this
      
  
  logout: ->
    this.setIfNotNull "accessToken", null
    this.setIfNotNull "URLToken", null
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
      FirehoseJS.client.URLToken       = @URLToken
      FirehoseJS.Agent.loggedInAgent   = this
      
  
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
    FirehoseJS.client.put( params )
        
        
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
    this.setIfNotNull "_password", newPassword


  fullName: ->
    "#{@firstName} #{@lastName}"
  
  
  _populateWithJSON: (json) ->
    this.setIfNotNull "accessToken", json.access_token unless @accessToken?
    this.setIfNotNull "urlToken",    json.url_token    unless @URLToken?
    this.setIfNotNull "firstName",   json.first_name
    this.setIfNotNull "lastName",    json.last_name
    this.setIfNotNull "email",       json.email
    
    this._populateAssociatedObjects this, "companies", json.companies, (json) =>
      FirehoseJS.Company.companyWithID( json.id, this )
      
    if @companies.length > 0 and not @currentCompany?
      this.setIfNotNull "currentCompany", @companies[0]
    
    super json
    
    
  _toJSON: ->
    agent:
      first_name: @firstName
      last_name:  @lastName
      email:      @email
      password:   @_password if @_password?
      
      
