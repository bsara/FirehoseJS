class FirehoseJS.Note extends FirehoseJS.Object
  
  
  interaction: null
  
  body: null
  
  agent: null
  
  
  @noteWithBody: (body, interaction) ->
    note = FirehoseJS.Object._objectOfClassWithID( FirehoseJS.Note, null )
    note.body         = body
    note.interaction  = interaction
    note 
  
        
  @_noteWithID: (id, interaction) ->
    note = FirehoseJS.Object._objectOfClassWithID( FirehoseJS.Note, id )
    note.interaction = interaction
    note     
    
        
  save: ->
    if @id?
      params = 
        route: "notes/#{@id}"
        body:  this._toJSON()
      FirehoseJS.client.put( params )
    else
      params = 
        route: "interactions/#{@interaction.id}/notes"
        body:  this._toJSON()
      FirehoseJS.client.post( params ).done (data) =>
        this._populateWithJSON data
        @interaction.notes.push this
        @interaction.notes.sort (note1, note2) ->
          note1.createdAt > note2.createdAt
      
      
  destroy: ->
    params = 
      route: "notes/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @interaction.notes.remove this
    

  _populateWithJSON: (json) ->
    @body = json.body
    
    this._populateAssociatedObjectWithJSON this, "agent", json.agent, (json) ->
      FirehoseJS.Agent.agentWithID( json.id )
      
    super json
    
    
  _toJSON: ->
    note:
      body: @body