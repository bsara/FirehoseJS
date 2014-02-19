class Firehose.Article extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "Article"
  
  ###
  @property [Company] 
  ###
  company: null
  
  ###
  @property [string] 
  ###
  slug: null
  
  ###
  @property [string] 
  ###
  title: null
  
  ###
  @property [string] 
  ###
  body: null
    
    
  @articleWithTitleBodyAndCompany: (title, body, company) ->
    Firehose.Object._objectOfClassWithID Firehose.Article,
      title:    title
      body:     body
      company:  company
  
  
  @articleWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.Article,
      id:      id
      company: company
  
  
  fetch: ->
    params = 
      auth:   false
      route:  "articles/#{@id}"
    Firehose.client.get( params ).done (data) =>
      this._populateWithJSON data


  save: ->
    if @id?
      params = 
        route: "articles/#{@id}"
        body:  this._toJSON()
      Firehose.client.put( params )
    else
      params = 
        route: "companies/#{@company.id}/articles"
        body:  this._toJSON()
      Firehose.client.post( params ).done (data) =>
        this._populateWithJSON data
        @company.articles().insertObject this
      
      
  destroy: ->
    params = 
      route: "articles/#{@id}"
    Firehose.client.delete( params ).done =>
      @company.articles().dropObject this
    

  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "title", json.title
    this._setIfNotNull "body",  json.body
    this._setIfNotNull "slug",  json.slug
    super json
    
    
  # @nodoc
  _toJSON: ->
    article:
      title:  @title
      body:   @body
