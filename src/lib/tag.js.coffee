class Firehose.Tag extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "Tag"
  
  ###
  @property [Company] 
  ###
  company: null
  
  ###
  @property [string] 
  ###
  label: null
  
  
  @tagWithLabel: (label, company) ->
    Firehose.Object._objectOfClassWithID Firehose.Tag,
      label:   label
      company: company


  # @nodoc
  @_tagWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.Tag,
      id:      id
      company: company
      
        
  save: ->
    if @id?
      params = 
        route: "tags/#{@id}"
        body:  this._toJSON()
      Firehose.client.put( params )
    else
      params = 
        route: "companies/#{@company.id}/tags"
        body:  this._toJSON()
      Firehose.client.post( params ).done (data) =>
        this._populateWithJSON data
        @company.tags.insertObject this
      
      
  destroy: ->
    params = 
      route: "tags/#{@id}"
    Firehose.client.delete( params ).done =>
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
