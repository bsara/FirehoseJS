class Firehose.Agent extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "Agent"
  
  ###
  @property [Agent] Once you call `login` or `signUPWith…` this will contain the logged in agent, available globally on the class.
  @example Firehose.Agent.loggedInAgent
  ###
  @loggedInAgent: null
  
  ###
  @property [string] Available once the agent is logged in. You can store this locally for automatic login on the user's next visit.
  ###
  accessToken: null
  
  ###
  @property [string] 
  ###
  URLToken: null
  
  ###
  @property [string] 
  ###
  firstName: null
  
  ###
  @property [string] 
  ###
  lastName: null
  
  ###
  @property [string] 
  ###
  email: null
  
  ###
  @property [Company] 
  ###
  currentCompany: null
  
  # @nodoc
  _password: null
  
  # associations
  
  companies: null 
  
  
  # @nodoc
  _setup: ->
    @companies = new Firehose.UniqueArray


  @agentWithAccessToken: (accessToken) ->
    Firehose.Object._objectOfClassWithID Firehose.Agent,
      accessToken: accessToken
      
      
  @agentWithEmailAndPassword: (email, password) ->
    Firehose.Object._objectOfClassWithID Firehose.Agent,
      email:        email
      _password:    password
      

  @agentWithID: (id) ->
    Firehose.Object._objectOfClassWithID Firehose.Agent,
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
        
    Firehose.client.post( params ).done (data) =>
      this._populateWithJSON data
      this._handleSuccessfulLogin()
  
  
  ###
  Logs the agent in and stores the access token for all future requests.
  @note If the username and password properties are set, they are used to log in and obtain an access token and populate the agent.
        If no username or password is set, but the accessToken is set, it will login using the access token and populate the agent.
  @return [Promise] A jqXHR Promise.
  ###
  login: ->    
    if @firstName? and @lastName and @email?
      this._handleSuccessfulLogin()
      return $.Deferred().resolve this._toArchivableJSON()
      
    Firehose.client.APIAccessToken = null
    
    params = 
      route: 'login'
    
    if @email? and @_password?
      params.body =
        email:    @email      
        password: @_password  
    else if @accessToken?
      Firehose.client.APIAccessToken = @accessToken
        
    Firehose.client.post( params ).done (data) =>
      this._populateWithJSON data
      this._handleSuccessfulLogin()
      
  
  ###
  Makes no call to the server but simply nulls out all the stored credentials that are used to authenticate requests.
  Any requests made after calling `logout()` on any agent will cause every request that requires authenticattion to fail.
  ###
  logout: ->
    this._setIfNotNull "accessToken", null
    this._setIfNotNull "URLToken", null
    Firehose.Agent.loggedInAgent        = null
    Firehose.client.APIAccessToken      = null
    Firehose.client.URLToken            = null
    Firehose.client.billingAccessToken  = null
    
  
  ###
  Fetches the latest data about this agent from the server and populates the agent's properties.
  @return [Promise] A jqXHR Promise.
  ###
  fetch: ->
    params = 
      route: "agents/#{@id}"
    Firehose.client.get( params ).done (data) =>
      this._populateWithJSON data
      this._handleSuccessfulLogin()
      
  
  ###
  Persists all properties that can be saved to the server.
  @return [Promise] A jqXHR Promise.
  ###
  save: ->
    params = 
      route: "agents/#{@id}"
      body:  this._toJSON()
    Firehose.client.put( params )
  
  
  ###
  Deletes this agent from the server.
  @note The logic of what this does is somewhat complex. The rules are: Every company this agent belongs to where this is the only agent the company has will be destroyed
        with the agent. Any company this agent belongs to that has other agents will not be destroyed and if the agent was the company's owner, the agent will still be 
        destroyed and a new owner will be selected from remaining agents at random.
  @return [Promise] A jqXHR Promise.
  ###
  destroy: ->
    params = 
      route: "agents/#{@id}"
    Firehose.client.delete( params ).done =>
      for company in @companies
        company.agents.dropObject this
    
  
  dismissNotifications: (notifications) ->
    ids = []
    for notification in notifications
      ids.push notification.id
    
    params = 
      route: "agents/#{@id}/notifications/#{ids.join(',')}"
    Firehose.client.put( params )
        
        
  @requestPasswordReset: (email) ->
    params = 
      route: "request_reset_password"
      body:
        email: email
    Firehose.client.post( params )
    
  
  @resetPassword: (token, newPassword) ->
    params = 
      route: "reset_password"
      body:
        token:    token
        password: newPassword
    Firehose.client.post( params )
    

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
  _handleSuccessfulLogin: =>
    Firehose.client.APIAccessToken = @accessToken
    Firehose.client.URLToken       = @URLToken
    Firehose.Agent.loggedInAgent   = this
    

  
  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "accessToken", json.access_token unless @accessToken?
    this._setIfNotNull "URLToken",    json.url_token    unless @URLToken?
    this._setIfNotNull "firstName",   json.first_name
    this._setIfNotNull "lastName",    json.last_name
    this._setIfNotNull "email",       json.email
    
    this._populateAssociatedObjects this, "companies", json.companies, (json) =>
      Firehose.Company.companyWithID( json.id, this )
      
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
      
  # @nodoc
  _toArchivableJSON: ->
    $.extend super(),
      access_token: @accessToken
      url_token:    @URLToken
      first_name:   @firstName
      last_name:    @lastName
      email:        @email
      password:     @_password if @_password?
      companies:    @companies?._toArchivableJSON()

  