class FirehoseJS.Tag extends FirehoseJS.Object
  
  
  company: null
  
  label: null
  
  
  constructor: (arg1, arg2) ->
    # with id 
    unless isNaN(parseInt(arg1))
      @id = arg1
      if arg2? and arg2.constructor == FirehoseJS.Company
        @company = arg2
    # with title and agent
    else if typeof(arg1) == 'string'
      @label = arg1
      if arg2.constructor == FirehoseJS.Company
        @company = arg2
        
  save: ->
    if @id?
      params = 
        route: "tags/#{@id}"
        body:  this._toJSON()
      FirehoseJS.client.put( params )
    else
      params = 
        route: "companies/#{@company.id}/tags"
        body:  this._toJSON()
      FirehoseJS.client.post( params ).done (data) =>
        this._populateWithJSON data
        @company.tags.push this
      
      
  destroy: ->
    params = 
      route: "tags/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @company.tags.remove this
    

  _populateWithJSON: (json) ->
    @label = json.label
    super json
    
    
  _toJSON: ->
    tag:
      label: @label