class FirehoseJS.AgentInvite extends FirehoseJS.Object
  
  
  toEmail: null
  
  company: null
  
  
  constructor: (arg1, arg2) ->
    # with id and company
    unless isNaN(parseInt(arg1))
      @id = arg1
      if arg2? and arg2.constructor == FirehoseJS.Company
        @company = arg2
      
    # with email and company
    else if typeof(arg1) == 'string'
      @toEmail = arg1
      if arg2.constructor == FirehoseJS.Company
        @company = arg2


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
