class FirehoseJS.AgentInvite extends FirehoseJS.Object
  
  
  # @nodoc
  @_firehoseType: "AgentInvite"
  
  toEmail: null
  
  company: null
  
  
  @agentInviteWithEmail: (email, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.AgentInvite,
      toEmail: email
      company: company


  # @nodoc
  @_agentInviteWithID: (id, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.AgentInvite,
      id:      id
      company: company
    

  save: ->
    params = 
      route: "companies/#{@company.id}/agent_invites"
      body:  this._toJSON()
    FirehoseJS.client.post( params ).done (data) =>
      this._populateWithJSON data
      @company.agentInvites.insertObject this
      
  
  resend: ->
    params = 
      route: "agent_invites/#{@id}/resend"
    FirehoseJS.client.put( params )
      
      
  destroy: ->
    params = 
      route: "agent_invites/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @company.agentInvites.dropObject this
    

  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "email", json.email
    super json
    
    
  # @nodoc
  _toJSON: ->
    agent_invite:
      email: @toEmail
