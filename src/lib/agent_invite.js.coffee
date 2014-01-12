class FirehoseJS.AgentInvite extends FirehoseJS.Object
  
  
  toEmail: null
  
  company: null
  
  
  @agentInviteWithEmail: (email, company) ->
    agentInvite = FirehoseJS.Object._objectOfClassWithID( FirehoseJS.AgentInvite, null )
    agentInvite.toEmail = email
    agentInvite.company = company
    agentInvite 


  @_agentInviteWithID: (id, company) ->
    agentInvite = FirehoseJS.Object._objectOfClassWithID( FirehoseJS.AgentInvite, id )
    agentInvite.company = company
    agentInvite 
    

  save: ->
    params = 
      route: "companies/#{@company.id}/agent_invites"
      body:  this._toJSON()
    FirehoseJS.client.post( params ).done (data) =>
      this._populateWithJSON data
      @company.agentInvites.push this
      
  
  resend: ->
    params = 
      route: "agent_invites/#{@id}/resend"
    FirehoseJS.client.put( params )
      
      
  destroy: ->
    params = 
      route: "agent_invites/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @company.agentInvites.remove this
    

  _populateWithJSON: (json) ->
    @email = json.email
    super json
    
    
  _toJSON: ->
    agent_invite:
      email: @toEmail
