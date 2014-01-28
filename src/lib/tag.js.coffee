class FirehoseJS.Tag extends FirehoseJS.Object
  
  
  # @nodoc
  @_firehoseType: "Tag"
  
  company: null
  
  label: null
  
  
  @tagWithLabel: (label, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Tag,
      label:   label
      company: company


  # @nodoc
  @_tagWithID: (id, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Tag,
      id:      id
      company: company
      
        
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
        @company.tags.insertObject this
      
      
  destroy: ->
    params = 
      route: "tags/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @company.tags.dropObject this
    

  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "label", json.label
    super json
    
    
  # @nodoc
  _toJSON: ->
    tag:
      label: @label
      
    # @nodoc
  _toArchivableJSON: ->
    $.extend super(),
      label: @label
