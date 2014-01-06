class FirehoseJS.Note extends FirehoseJS.Object
  
  
  interaction: null
  
  body: null
  
  agent: null
  
  
  constructor: (arg1, arg2) ->
    # with id 
    unless isNaN(parseInt(arg1))
      @id = arg1
      if arg2? and arg2 instanceof FirehoseJS.Interaction
        @interaction = arg2
    # with title and agent
    else if typeof(arg1) == 'string'
      @body = arg1
      if arg2 instanceof FirehoseJS.Interaction
        @interaction = arg2
        
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
    @body = json.label
    
    this._populateAssociatedObjectWithJSON this, "agent", json.agent, (json) ->
      new FirehoseJS.Agent( json.id )
      
    super json
    
    
  _toJSON: ->
    note:
      body: @body