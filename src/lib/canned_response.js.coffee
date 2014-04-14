class Firehose.CannedResponse extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "CannedResponse"
  
  ###
  @property [Company] The company this canned response belongs to.
  ###
  company: null
  
  ###
  @property [String] The name of this canned response.
  ###
  name: null
  
  ###
  @property [String] A string used for providing a fast shortcut that expands to the full canned response.
  @deprecated
  ###
  shortcut: null
  
  ###
  @property [String] The actual text of the canned response.
  ###
  text: null
    
  
  ###
  The designated method of creating a new canned response.  
  @param name [String] The short display name
  @param text [String] The actual text of the canned response
  @param company [Company] The company this canned response will belong to once saved to the server.
  ### 
  @cannedResponseWithNameAndText: (name, text, company) ->
    Firehose.Object._objectOfClassWithID Firehose.CannedResponse,
      name:    name
      text:    text
      company: company
  
        
  # @nodoc
  @_cannedResponseWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.CannedResponse,
      id:      id
      company: company


  ###
  Save the canned response to the server.
  @return [Promise] A jqXHR Promise.
  @note If it has never been saved, it creates it on the server. Otherwise it updates it.
  @example Creating and saving a canned response.
    cannedResponse = Firehose.CannedResponse.cannedResponseWithNameAndText "Name", "Canned Response", company
    cannedResponse.save().done ->
      console.log "saved!"
  ### 
  save: ->
    if @id?
      params = 
        route: "canned_responses/#{@id}"
        body:  this._toJSON()
      Firehose.client.put( this, params )
    else
      params = 
        route: "companies/#{@company.id}/canned_responses"
        body:  this._toJSON()
      Firehose.client.post( this, params ).done (data) =>
        this._populateWithJSON data
        @company.cannedResponses.insertObject this
      
      
  ###
  Destroy this canned response from the server.
  @return [Promise] A jqXHR Promise.
  ### 
  destroy: ->
    params = 
      route: "canned_responses/#{@id}"
    Firehose.client.delete( this, params ).done =>
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

 
   # @nodoc
  _toArchivableJSON: ->
    $.extend super(),
      name:     @name
      shortcut: @shortcut
      text:     @text
