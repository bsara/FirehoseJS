class Firehose.Customer extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "Customer"
  
  ###
  @property [Company] 
  ###
  company: null
  
  ###
  @property [string] 
  ###
  name: null
  
  ###
  @property [string] 
  ###
  location: null
  
  ###
  @property [string] 
  ###
  timeZone: null
  
  ###
  @property [integer] 
  ###
  newestInteractionId: null
  
  ###
  @property [string] 
  ###
  newestInteractionExcerpt: null
  
  ###
  @property [Date] 
  ###
  newestInteractionReceivedAt: null
  
  ###
  @property [Agent] 
  ###
  agentWithDibs: null
  
  # associations
  
  ###
  @property [Array<CustomerAccount>] 
  ###
  customerAccounts: null
  
  ###
  @property [Array<Agent>] 
  ###
  customerFlaggedAgents: null
  
  # remote arrays
  
  # @nodoc
  _interactions: null
  
  
  # @nodoc
  _setup: ->
    @customerAccounts = new Firehose.UniqueArray
    @customerFlaggedAgents = new Firehose.UniqueArray
    @customerFlaggedAgents.sortOn "firstName"
  
  
  ###
  If you have a customer's id, you can create a customer object and then call `fetch` to populate it.
  @param [number] The customer identifier.
  @param [Company] The company this customer belongs to.
  @return [Customer] A customer you can now call `fetch` on to populate.
  ### 
  @customerWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.Customer,
      id:      id
      company: company
      
      
  ###
  In a customer list, sometimes a pusher event can send you customer json and you need a way to create a customer from it.
  @param [Object] JSON of the customer.
  @param [Company] The company this customer belongs to.
  @return [Customer] A customer populated with the JSON.
  ### 
  @customerWithJSON: (json, company) ->
    customer = @customerWithID json.id, company
    customer._populateWithJSON json
    customer
  
  
  ###
  If the customer has a valid `id` this will fetch and populate this customer object with data on the server.
  @return [Promise] A jqXHR object.
  ###  
  fetch: ->
    params = 
      route: "customers/#{@id}"
    Firehose.client.get( this, params ).done (data) =>
      this._populateWithJSON data
    
    
  resolveAllInteractions: ->
    params = 
      route: "customers/#{@id}/resolve_all_interactions"
    Firehose.client.put( this, params )
    
    
  destroy: ->
    params = 
      route: "customers/#{@id}"
    Firehose.client.delete( this, params ).done =>
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
      
    this._populateAssociatedObjects this, "customerFlaggedAgents", json.interaction_flagged_agents, (json) ->
      Firehose.Agent.agentWithID( json.id )
    
    this._populateAssociatedObjectWithJSON this, "agentWithDibs", json.agent_with_dibs, (json) ->
      Firehose.Agent.agentWithID( json.id )
    
    super json
  