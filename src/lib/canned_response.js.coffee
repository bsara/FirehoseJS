class FirehoseJS.CannedResponse extends FirehoseJS.Object
  
  
  firehoseType: "CannedResponse"
  
  company: null
  
  name: null
  
  shortcut: null
  
  text: null
    
    
  @cannedResponseWithNameAndText: (name, text, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.CannedResponse,
      name:    name
      text:    text
      company: company
  
        
  @_cannedResponseWithID: (id, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.CannedResponse,
      id:      id
      company: company


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
        @company.cannedResponses.insertObject this
      
      
  destroy: ->
    params = 
      route: "canned_responses/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @company.cannedResponses.dropObject this
    

  _populateWithJSON: (json) ->
    this.setIfNotNull "name",     json.name
    this.setIfNotNull "shortcut", json.shortcut
    this.setIfNotNull "text",     json.text
    super json
    
    
  _toJSON: ->
    canned_response:
      name:     @name
      shortcut: @shortcut
      text:     @text