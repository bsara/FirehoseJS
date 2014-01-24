class FirehoseJS.CannedResponse extends FirehoseJS.Object
  
  
  # @nodoc
  @_firehoseType: "CannedResponse"
  
  ###
  @property [Comany] The company this canned response belongs to.
  ###
  company: null
  
  ###
  @property [string] The name of this canned response.
  ###
  name: null
  
  ###
  @property [string] A string used for providing a fast shortcut that expands to the full canned response.
  @deprecated
  ###
  shortcut: null
  
  ###
  @property [string] The actual text of the canned response.
  ###
  text: null
    
  
  ###
  The designated method of creating a new canned response.  
  @param name [string] The short display name
  @param text [string] The actual text of the canned response
  @param company [Company] The company this canned response will belong to once saved to the server.
  ### 
  @cannedResponseWithNameAndText: (name, text, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.CannedResponse,
      name:    name
      text:    text
      company: company
  
        
  # @nodoc
  @_cannedResponseWithID: (id, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.CannedResponse,
      id:      id
      company: company


  ###
  Save the canned response to the server.
  @return [Promise] A jqXHR Promise.
  @note If it has never been saved, it creates it on the server. Otherwise it updates it.
  @example Creating and saving a canned response.
    cannedResponse = FirehoseJS.CannedResponse.cannedResponseWithNameAndText "Name", "Canned Response", company
    cannedResponse.save().done ->
      console.log "saved!"
  ### 
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
      
      
  ###
  Destroy this canned response from the server.
  @return [Promise] A jqXHR Promise.
  ### 
  destroy: ->
    params = 
      route: "canned_responses/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @company.cannedResponses.dropObject this
    

  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "name",     json.name
    this._setIfNotNull "shortcut", json.shortcut
    this._setIfNotNull "text",     json.text
    super json
    
    
  # @nodoc
  _toJSON: ->
    canned_response:
      name:     @name
      shortcut: @shortcut
      text:     @text

 