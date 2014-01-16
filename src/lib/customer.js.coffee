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
    FirehoseJS.client.delete( params )
  
  
  interactions: ->
    unless @_interactions?
      this.setIfNotNull "_interactions", new FirehoseJS.RemoteArray "customers/#{@id}/interactions", null, (json) =>
        FirehoseJS.Interaction._interactionWithJSON( json, this )
    @_interactions
    
    
  _populateWithJSON: (json) ->
    this.setIfNotNull "name",                         json.name
    this.setIfNotNull "location",                     json.location
    this.setIfNotNull "timeZone",                     json.time_zone
    this.setIfNotNull "newestInteractionId",          json.newest_interaction_id
    this.setIfNotNull "newestInteractionExcerpt",     json.newest_interaction_excerpt
    this.setIfNotNull "newestInteractionReceivedAt",  Date.parse json.newest_interaction_received_at
    
    this._populateAssociatedObjects this, "customerAccounts", json.customer_accounts, (json) =>
      FirehoseJS.CustomerAccount._customerAccountWithID( json.id, this )
      
    this._populateAssociatedObjects this, "interactionFlaggedAgents", json.interaction_flagged_agents, (json) ->
      FirehoseJS.Agent.agentWithID( json.id )
    
    this._populateAssociatedObjectWithJSON this, "agentWithDibs", json.agent_with_dibs, (json) ->
      FirehoseJS.Agent.agentWithID( json.id )
    
    super json
  