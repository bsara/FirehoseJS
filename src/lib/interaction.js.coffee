class FirehoseJS.Interaction extends FirehoseJS.Object
      
  
  customer: null
  
  token: null
  
  responseDraft: null
  
  happiness: null
  
  resolved: false
  
  body: null
  
  privateURL: null
  
  channel: null
  
  receivedAt: null
  
  customerAccount: null
  
  agent: null
  
  # associations
  
  responseInteractions: new FirehoseJS.UniqueArray
  
  notes: new FirehoseJS.UniqueArray
  
  tags: new FirehoseJS.UniqueArray
  
  flaggedAgents: new FirehoseJS.UniqueArray
    
    
  @_interactionWithJSON: (json, customer) ->
    interaction = null
    if json.channel == "twitter"
      interaction = FirehoseJS.TwitterInteraction._twitterInteractionWithID( json.id )
    else if json.channel == "facebook"    
      interaction = FirehoseJS.FacebookInteraction._facebookInteractionWithID( json.id )
    else if json.channel == "email"
      interaction = FirehoseJS.EmailInteraction._emailInteractionWithID( json.id )
    interaction.customer = customer
    interaction._populateWithJSON json
    interaction
    
  
  subject: ->
    if this.constructor == FirehoseJS.EmailInteraction    
      return this.emailSubject
    else if this.constructor == FirehoseJS.TwitterInteraction
      return if this.inReplyToScreenName then "Reply to #{this.inReplyToScreenName}" else "Mention of #{this.toScreenName}"
    else if this.constructor == FirehoseJS.FacebookInteraction
      return this.type[0].toUpperCase() + this.type.slice(1)
  
  
  reply: ->
    body =
      interaction:
        body: @responseDraft
    params = 
      route: "interactions/#{@id}/reply"
      body:  body
    FirehoseJS.client.post( params ).done (data) =>
      @responseDraft = null
      response = FirehoseJS.Interaction._interactionWithJSON( data, @customer )
      @responseInteractions.push response
      response.agent = FirehoseJS.Agent.loggedInAgent
      @responseInteractions.sort (interaction1, interaction2) ->
        interaction1.createdAt > interaction2.createdAt
    
    
  save: ->
    params = 
      route: "interactions/#{@id}"
      body:  this._toJSON()
    FirehoseJS.client.put( params )
    
    
  destroy: ->
    params = 
      route: "interactions/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @customer.interactions().remove this
    
    
  addTag: (tag) ->
    params = 
      route: "interactions/#{@id}/tags/#{tag.id}"
    FirehoseJS.client.put( params ).done =>
      @tags.push tag
    
    
  removeTag: (tag) ->
    params = 
      route: "interactions/#{@id}/tags/#{tag.id}"
    FirehoseJS.client.delete( params ).done =>
      @tags.remove tag
    
    
  flagAgent: (agent) ->
    params = 
      route: "interactions/#{@id}/agents/#{agent.id}"
    FirehoseJS.client.put( params ).done =>
      @flaggedAgents.push agent
    
  
  unflagAgent: (agent) ->
    params = 
      route: "interactions/#{@id}/agents/#{agent.id}"
    FirehoseJS.client.delete( params ).done =>
      @flaggedAgents.remove agent
    
  
  happinessString: ->
    if @happiness == 0
      "Upset"
    else if @happiness == 1
      "Satisfied"
    else if @happiness == 2
      "Happy"
    
    
  _populateWithJSON: (json) ->
    @token          ?= json.token
    @body           = json.body
    @responseDraft  = json.response_draft
    @channel        = json.channel
    @receivedAt     = Date.parse json.received_at
    @privateURL     = json.private_url
    @happiness      = json.happiness
    @resolved       = json.resolved
    
    this._populateAssociatedObjectWithJSON this, "agent", json.agent, (json) ->
      FirehoseJS.Agent.agentWithID( json.id )
      
    this._populateAssociatedObjectWithJSON this, "customerAccount", json.customer_account, (json) =>
      FirehoseJS.CustomerAccount._customerAccountWithID( json.id, @customer )
    
    this._populateAssociatedObjects this, "responseInteractions", json.response_interactions, (json) =>
      json.channel = @channel
      FirehoseJS.Interaction._interactionWithJSON( json, @customer )
      
    this._populateAssociatedObjects this, "notes", json.notes, (json) =>
      FirehoseJS.Note._noteWithID( json.id, this )
      
    this._populateAssociatedObjects this, "tags", json.tags, (json) =>
      FirehoseJS.Tag._tagWithID( json.id, @customer.company )
      
    this._populateAssociatedObjects this, "flaggedAgents", json.flagged_agents, (json) =>
      FirehoseJS.Agent.agentWithID( json.id )
      
    super json
    
    
  _toJSON: ->
    interaction:
      resolved:       @resolved
      response_draft: @responseDraft
