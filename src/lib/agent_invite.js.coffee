class Firehose.AgentInvite extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "AgentInvite"
  
  ###
  @property [string] 
  ###
  toEmail: null
  
  ###
  @property [Company] 
  ###
  company: null
  
  
  @agentInviteWithEmail: (email, company) ->
    Firehose.Object._objectOfClassWithID Firehose.AgentInvite,
      toEmail: email
      company: company


  # @nodoc
  @_agentInviteWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.AgentInvite,
      id:      id
      company: company
    

  save: ->
    params = 
      route: "companies/#{@company.id}/agent_invites"
      body:  this._toJSON()
    Firehose.client.post( this, params ).done (data) =>
      this._populateWithJSON data
      @company.agentInvites.insertObject this
      
  
  resend: ->
    params = 
      route: "agent_invites/#{@id}/resend"
    Firehose.client.put( this, params )
      
      
  destroy: ->
    params = 
      route: "agent_invites/#{@id}"
    Firehose.client.delete( this, params ).done =>
      @company.agentInvites.dropObject this
    

  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "email", json.email
    super json
    
    
  # @nodoc
  _toJSON: ->
    agent_invite:
      email: @toEmail

  # @nodoc
  _toArchivableJSON: ->
    $.extend super(),
      email:                @toEmail