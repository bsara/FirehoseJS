class FirehoseJS.Tag extends FirehoseJS.Object
  
  
  company: null
  
  label: null
  
  
  @tagWithLabel: (label, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Tag,
      label:   label
      company: company
        
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
        @company.tags.push this
      
      
  destroy: ->
    params = 
      route: "tags/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @company.tags.remove this
    

  _populateWithJSON: (json) ->
    this.set "label", json.label
    super json
    
    
  _toJSON: ->
    tag:
      label: @label