class FirehoseJS.Article extends FirehoseJS.Object
  
  
  # @nodoc
  @_firehoseType: "Article"
  
  company: null
  
  title: null
  
  body: null
    
    
  @articleWithTitleBodyAndCompany: (title, body, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Article,
      title:    title
      body:     body
      company:  company
  
  
  @articleWithID: (id, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Article,
      id:      id
      company: company
  
  
  fetch: ->
    params = 
      route: "articles/#{@id}"
    FirehoseJS.client.get( params ).done (data) =>
      this._populateWithJSON data


  save: ->
    if @id?
      params = 
        route: "articles/#{@id}"
        body:  this._toJSON()
      FirehoseJS.client.put( params )
    else
      params = 
        route: "companies/#{@company.id}/articles"
        body:  this._toJSON()
      FirehoseJS.client.post( params ).done (data) =>
        this._populateWithJSON data
        @company.articles().insertObject this
      
      
  destroy: ->
    params = 
      route: "articles/#{@id}"
    FirehoseJS.client.delete( params ).done =>
      @company.articles().dropObject this
    

  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "title", json.title
    this._setIfNotNull "body",  json.body
    super json
    
    
  # @nodoc
  _toJSON: ->
    article:
      title:  @title
      body:   @body