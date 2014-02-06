class Firehose.Customer extends Firehose.Object
  
  
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
    @customerAccounts = new Firehose.UniqueArray
    @customerFlaggedAgents = new Firehose.UniqueArray
    @customerFlaggedAgents.sortOn "firstName"
  
    
  @customerWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.Customer,
      id:      id
      company: company
  
  
  fetch: ->
    params = 
      route: "customers/#{@id}"
    Firehose.client.get( params ).done (data) =>
      this._populateWithJSON data
    
    
  resolveAllInteractions: ->
    params = 
      route: "customers/#{@id}/resolve_all_interactions"
    Firehose.client.put( params )
    
    
  destroy: ->
    params = 
      route: "customers/#{@id}"
    Firehose.client.delete( params ).done =>
      @company._customers?.dropObject this
  
  
  interactions: ->
    unless @_interactions?
      this._setIfNotNull "_interactions", new Firehose.RemoteArray "customers/#{@id}/interactions", null, (json) =>
        Firehose.Interaction._interactionWithJSON( json, this )
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
      Firehose.CustomerAccount._customerAccountWithID( json.id, this )
      
    this._populateAssociatedObjects this, "interactionFlaggedAgents", json.interaction_flagged_agents, (json) ->
      Firehose.Agent.agentWithID( json.id )
    
    this._populateAssociatedObjectWithJSON this, "agentWithDibs", json.agent_with_dibs, (json) ->
      Firehose.Agent.agentWithID( json.id )
    
    super json
  