class FirehoseJS.Note extends FirehoseJS.Object
  
  
  interaction: null
  
  body: null
  
  agent: null
  
  
  @noteWithBody: (body, interaction) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Note,
      body:        body
      interaction: interaction
  
        
  @_noteWithID: (id, interaction) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Note,
      id:          id
      interaction: interaction
    
        
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
    this.setIfNotNull "body", json.body
    
    this._populateAssociatedObjectWithJSON this, "agent", json.agent, (json) ->
      FirehoseJS.Agent.agentWithID( json.id )
      
    super json
    
    
  _toJSON: ->
    note:
      body: @body