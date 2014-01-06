class FirehoseJS.CannedResponse extends FirehoseJS.Object
  
  
  company: null
  
  name: null
  
  shortcut: null
  
  text: null
  
  
  constructor: (arg1, arg2, arg3) ->
    # with id and company
    unless isNaN(parseInt(arg1))
      @id = arg1
      if arg2? and arg2.constructor == FirehoseJS.Company
        @company = arg2
      
    # with name, text and company
    else if typeof(arg1) == 'string'
      @name = arg1
      if typeof(arg2) == 'string'
        @text = arg2
      if arg3.constructor == FirehoseJS.Company
        @company = arg3


  save: ->
    if @id?
      params = 
        route: "canned_responses/#{@id}"
        body:  this._toJSON()
      FirehoseJS.client.put( params )
    else
      params = 
        route: "companies/#{@company.id}/canned_responses"
        body:  this._toJSON()
      FirehoseJS.client.post( params ).done (data) =>
        this._populateWithJSON data
        @company.cannedResponses.push this
      
      
  destroy: ->
    params = 
      route: "canned_responses/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @company.cannedResponses.remove this
    

  _populateWithJSON: (json) ->
    @name     = json.name
    @shortcut = json.shortcut
    @text     = json.text
    super json
    
    
  _toJSON: ->
    canned_response:
      name:     @name
      shortcut: @shortcut
      text:     @text