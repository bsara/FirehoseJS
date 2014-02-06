class Firehose.Note extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "Note"
  
  interaction: null
  
  body: null
  
  agent: null
  
  
  @noteWithBody: (body, interaction) ->
    Firehose.Object._objectOfClassWithID Firehose.Note,
      body:        body
      interaction: interaction
  
        
  # @nodoc
  @_noteWithID: (id, interaction) ->
    Firehose.Object._objectOfClassWithID Firehose.Note,
      id:          id
      interaction: interaction
    
        
  save: ->
    if @id?
      params = 
        route: "notes/#{@id}"
        body:  this._toJSON()
      Firehose.client.put( params )
    else
      params = 
        route: "interactions/#{@interaction.id}/notes"
        body:  this._toJSON()
      Firehose.client.post( params ).done (data) =>
        this._populateWithJSON data
        @interaction.notes.insertObject this
        
      
  destroy: ->
    params = 
      route: "notes/#{@id}"
    Firehose.client.delete( params ).done =>
      @interaction.notes.dropObject this
    

  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "body", json.body
    
    this._populateAssociatedObjectWithJSON this, "agent", json.agent, (json) ->
      Firehose.Agent.agentWithID( json.id )
      
    super json
    
    
  # @nodoc
  _toJSON: ->
    note:
      body: @body