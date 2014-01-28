class FirehoseJS.Agent extends FirehoseJS.Object
  
  
  # @nodoc
  @_firehoseType: "Agent"
  
  @loggedInAgent: null
  
  accessToken: null
  
  URLToken: null
  
  firstName: null
  
  lastName: null
  
  email: null
  
  currentCompany: null
  
  # @nodoc
  _password: null
  
  # associations
  
  companies: null 
  
  
  # @nodoc
  _setup: ->
    @companies = new FirehoseJS.UniqueArray


  @agentWithAccessToken: (accessToken) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Agent,
      accessToken: accessToken
      
      
  @agentWithEmailAndPassword: (email, password) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Agent,
      email:        email
      _password:    password
      

  @agentWithID: (id) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Agent,
      id: id
    
  ###
  Create a new agent.
  @param firstName [string] The first name of the agent that will be shown in the interace and to customers.
  @param lastName [string] The last name of the agent.
  @param inviteToken [string] If The user is accepting an invite from an email, the invite token will be in the url and you can pass it in here to link this agent to that company when they sign up.
  @return [Promise] a jqXHR Promise.
  ###
  signUpWithFirstAndLastName: (firstName, lastName, inviteToken) ->
    this._setIfNotNull "firstName", firstName
    this._setIfNotNull "lastName",  lastName
    
    params = 
      route: 'agents'
      body:   
        token: inviteToken if inviteToken?
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
    this._setIfNotNull "accessToken", null
    this._setIfNotNull "URLToken", null
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
    FirehoseJS.client.delete( params ).done =>
      for company in @companies
        company.agents.dropObject this
    
  
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
    this._setIfNotNull "_password", newPassword


  fullName: ->
    "#{@firstName} #{@lastName}"
    
    
  ###
  The agents gravatar given their email address.
  @return [string] the url of the agent's gravatar.
  ###
  gravatarURL: ->
    if @email
      e = @email.trim().toLowerCase()
      hashedEmail = md5(e)
    "https://www.gravatar.com/avatar/#{hashedEmail}?d=identicon"

  
  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "accessToken", json.access_token unless @accessToken?
    this._setIfNotNull "URLToken",    json.url_token    unless @URLToken?
    this._setIfNotNull "firstName",   json.first_name
    this._setIfNotNull "lastName",    json.last_name
    this._setIfNotNull "email",       json.email
    
    this._populateAssociatedObjects this, "companies", json.companies, (json) =>
      FirehoseJS.Company.companyWithID( json.id, this )
      
    if @companies.length > 0 and not @currentCompany?
      this._setIfNotNull "currentCompany", @companies[0]
    
    super json
    
    
  # @nodoc
  _toJSON: ->
    agent:
      first_name: @firstName
      last_name:  @lastName
      email:      @email
      password:   @_password if @_password?
      
      
