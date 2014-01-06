class FirehoseJS.Customer extends FirehoseJS.Object
  
  
  company: null
  
  name: null
  
  location: null
  
  timeZone: null
  
  newestInteractionId: null
  
  newestInteractionExcerpt: null
  
  newestInteractionReceivedAt: null
  
  agentWithDibs: null
  
  # associations
  
  customerAccounts: new FirehoseJS.UniqueArray
  
  customerFlaggedAgents: new FirehoseJS.UniqueArray
  
  # remote arrays
  
  _interactions: null
  
  
  constructor: (id, company) ->
    @id       = id
    @company  = company if company
    
  
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
    FirehoseJS.client.delete( params )
  
  
  interactions: ->
    unless @_interactions?
      @_interactions = new FirehoseJS.RemoteArray "customers/#{@id}/interactions", null, (json) =>
        new FirehoseJS.Interaction.interactionWithJSON( json, this )
    @_interactions
    
    
  _populateWithJSON: (json) ->
    @name                         = json.name
    @location                     = json.location
    @timeZone                     = json.time_zone
    @newestInteractionId          = json.newest_interaction_id
    @newestInteractionExcerpt     = json.newest_interaction_excerpt
    @newestInteractionReceivedAt  = Date.parse json.newest_interaction_received_at
    
    this._populateAssociatedObjects this, "customerAccounts", json.customer_accounts, (json) ->
      new FirehoseJS.CustomerAccount( json.id, this )
      
    this._populateAssociatedObjects this, "interactionFlaggedAgents", json.interaction_flagged_agents, (json) ->
      new FirehoseJS.Agent( json.id )
    
    this._populateAssociatedObjectWithJSON this, "agentWithDibs", json.agent_with_dibs, (json) ->
      new FirehoseJS.Agent( json.id )
    
    super json
  