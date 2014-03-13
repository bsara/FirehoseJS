class Firehose.Interaction extends Firehose.Object
      
  # @nodoc
  @_firehoseType: "Interaction"
  
  ###
  @property [Customer] 
  ###
  customer: null
  
  ###
  @property [string] 
  ###
  token: null
  
  ###
  @property [string] 
  ###
  responseDraft: null
  
  ###
  @property [integer] 1 = unhappy, 2 = satisfied, 3 = happy
  @deprecated
  ###
  happiness: null
  
  ###
  @property [boolean] 
  ###
  resolved: false
  
  ###
  @property [boolean] 
  ###
  isOutgoing: null
  
  ###
  @property [string] 
  ###
  body: null
  
  ###
  @property [string] 
  ###
  privateURL: null
  
  ###
  @property [string] What channel the interaction is through (email, fb, twitter)
  ###
  channel: null
  
  ###
  @property [Date] 
  ###
  receivedAt: null
  
  ###
  @property [CustomerAccount] The account this interaction is linked to.
  ###
  customerAccount: null
  
  ###
  @property [Agent] If this is a response interaction, the agent that wrote it.
  ###
  agent: null
  
  
  # associations
  
  ###
  @property [Interaction] 
  ###
  originalInteraction: null
  
  ###
  @property [Array<Interaction>] 
  ###
  responseInteractions: null
  
  ###
  @property [Array<Note>] 
  ###
  notes: null
  
  ###
  @property [Array<Tag>] 
  ###
  tags: null
  
  ###
  @property [Array<Agent>] 
  ###
  flaggedAgents: null
  
  
  # @nodoc
  _setup: ->
    @responseInteractions = new Firehose.UniqueArray
    @notes                = new Firehose.UniqueArray
    @tags                 = new Firehose.UniqueArray
    @flaggedAgents        = new Firehose.UniqueArray
    @responseInteractions.sortOn "receivedAt"
    @notes.sortOn "createdAt"
    @tags.sortOn "label"
    @flaggedAgents.sortOn "firstName"
    
  
  ###
  Used to create a generic interaction that can then be fetched, without authentication, by the token.
  @param token [string] 
  @note: Any interactions is publicly visible with a token.
  @return [Interaction] a generic interaction object.
  ### 
  @interactionWithToken: (token) ->
    Firehose.Object._objectOfClassWithID Firehose.Interaction,
      token: token
    
    
  # @nodoc
  @_interactionWithJSON: (json, customer) ->
    interaction = null
    if json.channel == "twitter"
      interaction = Firehose.TwitterInteraction._twitterInteractionWithID( json.id )
    else if json.channel == "facebook"    
      interaction = Firehose.FacebookInteraction._facebookInteractionWithID( json.id )
    else if json.channel == "email"
      interaction = Firehose.EmailInteraction._emailInteractionWithID( json.id )
    interaction._setCustomer customer
    interaction._populateWithJSON json
    interaction
    
  
  subject: ->
    if this.constructor._firehoseType == "EmailInteraction"
      return this.emailSubject
    else if this.constructor._firehoseType == "TwitterInteraction"
      return if this.inReplyToScreenName then "Reply to #{this.inReplyToScreenName}" else "Mention of #{this.toScreenName}"
    else if this.constructor._firehoseType == "FacebookInteraction"
      return this.type[0].toUpperCase() + this.type.slice(1)
  
  
  reply: ->
    body =
      interaction:
        body: @responseDraft
    params = 
      route: "interactions/#{@id}/reply"
      body:  body
    Firehose.client.post( this, params ).done (data) =>
      this._setIfNotNull "responseDraft", null
      response = Firehose.Interaction._interactionWithJSON( data, @customer )
      @responseInteractions.insertObject response
      response._setIfNotNull "agent", Firehose.Agent.loggedInAgent
      @responseInteractions.sort (interaction1, interaction2) ->
        interaction1.createdAt > interaction2.createdAt
    
    
  save: ->
    params = 
      route: "interactions/#{@id}"
      body:  this._toJSON()
    Firehose.client.put( this, params )
    
    
  ###
  Fetches the latest data from the server and populates the object's properties with it.
  @note: If an id is used, an access token is required and you will a more comprehensive JSON object in return. If no id is present, but a token is, it will fetch without authentication.
  @return [Promise] a jqXHR Promise
  ###
  fetch: ->
    params =
      route: "interactions/#{@token || @id}"
    Firehose.client.get( this, params ).done (data) =>
      this._populateWithJSON data
      
    
  destroy: ->
    params = 
      route: "interactions/#{@id}"
    Firehose.client.delete( this, params ).done =>
      @customer.interactions().dropObject this
    
    
  addTag: (tag) ->
    params = 
      route: "interactions/#{@id}/tags/#{tag.id}"
    Firehose.client.put( this, params ).done =>
      @tags.insertObject tag
    
    
  removeTag: (tag) ->
    params = 
      route: "interactions/#{@id}/tags/#{tag.id}"
    Firehose.client.delete( this, params ).done =>
      @tags.dropObject tag
    
    
  flagAgent: (agent) ->
    params = 
      route: "interactions/#{@id}/agents/#{agent.id}"
    Firehose.client.put( this, params ).done =>
      @flaggedAgents.insertObject agent
    
  
  unflagAgent: (agent) ->
    params = 
      route: "interactions/#{@id}/agents/#{agent.id}"
    Firehose.client.delete( this, params ).done =>
      @flaggedAgents.dropObject agent
    
  
  happinessString: ->
    if @happiness == 0
      "Upset"
    else if @happiness == 1
      "Satisfied"
    else if @happiness == 2
      "Happy"
      
      
  # @nodoc
  _setCustomer: (customer) ->
    this._setIfNotNull "customer", customer
    
    
  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "token",         json.token unless @token?
    this._setIfNotNull "body",          json.body
    this._setIfNotNull "responseDraft", json.response_draft
    this._setIfNotNull "channel",       json.channel
    this._setIfNotNull "receivedAt",    Date.parse(json.received_at)
    this._setIfNotNull "privateURL",    json.private_url
    this._setIfNotNull "happiness",     json.happiness
    this._setIfNotNull "resolved",      json.resolved
    this._setIfNotNull "isOutgoing",    json.outgoing
    
    this._populateAssociatedObjectWithJSON this, "agent", json.agent, (json) ->
      Firehose.Agent.agentWithID( json.id )
      
    this._populateAssociatedObjectWithJSON this, "customerAccount", json.customer_account, (json) =>
      json.channel = @channel
      Firehose.CustomerAccount._customerAccountWithID( json.id, @customer )
    
    this._populateAssociatedObjects this, "responseInteractions", json.response_interactions, (json) =>
      json.channel = @channel
      interaction = Firehose.Interaction._interactionWithJSON( json, @customer )
      interaction.set 'originalInteraction', this
      interaction
      
    this._populateAssociatedObjects this, "notes", json.notes, (json) =>
      Firehose.Note._noteWithID( json.id, this )
      
    this._populateAssociatedObjects this, "tags", json.tags, (json) =>
      Firehose.Tag._tagWithID( json.id, @customer.company )
      
    this._populateAssociatedObjects this, "flaggedAgents", json.flagged_agents, (json) =>
      Firehose.Agent.agentWithID( json.id )
      
    super json
    
    
  # @nodoc
  _toJSON: ->
    interaction:
      resolved:       @resolved
      response_draft: @responseDraft
