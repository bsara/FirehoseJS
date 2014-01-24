class FirehoseJS.Customer extends FirehoseJS.Object
  
  
  # @nodoc
  @_firehoseType: "Customer"
  
  company: null
  
  name: null
  
  location: null
  
  timeZone: null
  
  newestInteractionId: null
  
  newestInteractionExcerpt: null
  
  newestInteractionReceivedAt: null
  
  agentWithDibs: null
  
  # associations
  
  customerAccounts: null
  
  customerFlaggedAgents: null
  
  # remote arrays
  
  # @nodoc
  _interactions: null
  
  
  # @nodoc
  _setup: ->
    @customerAccounts = new FirehoseJS.UniqueArray
    @customerFlaggedAgents = new FirehoseJS.UniqueArray
    @customerFlaggedAgents.sortOn "firstName"
  
    
  @customerWithID: (id, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Customer,
      id:      id
      company: company
  
  
  fetch: ->
    params = 
      route: "customers/#{@id}"
    FirehoseJS.client.get( params ).done (data) =>
      this._populateWithJSON data
    
    
  resolveAllInteractions: ->
    params = 
      route: "customers/#{@id}/resolve_all_interactions"
    FirehoseJS.client.put( params )
    
    
  destroy: ->
    params = 
      route: "customers/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @company._customers?.dropObject this
  
  
  interactions: ->
    unless @_interactions?
      this._setIfNotNull "_interactions", new FirehoseJS.RemoteArray "customers/#{@id}/interactions", null, (json) =>
        FirehoseJS.Interaction._interactionWithJSON( json, this )
      @_interactions.sortOn "receivedAt"
    @_interactions
    
    
  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "name",                         json.name
    this._setIfNotNull "location",                     json.location
    this._setIfNotNull "timeZone",                     json.time_zone
    this._setIfNotNull "newestInteractionId",          json.newest_interaction_id
    this._setIfNotNull "newestInteractionExcerpt",     json.newest_interaction_excerpt
    this._setIfNotNull "newestInteractionReceivedAt",  Date.parse json.newest_interaction_received_at
    
    this._populateAssociatedObjects this, "customerAccounts", json.customer_accounts, (json) =>
      FirehoseJS.CustomerAccount._customerAccountWithID( json.id, this )
      
    this._populateAssociatedObjects this, "interactionFlaggedAgents", json.interaction_flagged_agents, (json) ->
      FirehoseJS.Agent.agentWithID( json.id )
    
    this._populateAssociatedObjectWithJSON this, "agentWithDibs", json.agent_with_dibs, (json) ->
      FirehoseJS.Agent.agentWithID( json.id )
    
    super json
  