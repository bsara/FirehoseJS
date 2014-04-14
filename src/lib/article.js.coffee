class Firehose.Article extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "Article"
  
  ###
  @property [Product] 
  ###
  product: null
  
  ###
  @property [String] 
  ###
  slug: null
  
  ###
  @property [String] 
  ###
  title: null
  
  ###
  @property [String] 
  ###
  body: null
    
    
  @articleWithTitleAndBody: (title, body, product) ->
    Firehose.Object._objectOfClassWithID Firehose.Article,
      title:    title
      body:     body
      product:  product
  
  
  @articleWithID: (id, product) ->
    Firehose.Object._objectOfClassWithID Firehose.Article,
      id:      id
      product: product
  
  
  fetch: ->
    params = 
      auth:   false
      route:  "articles/#{@id}"
    Firehose.client.get( this, params ).done (data) =>
      this._populateWithJSON data


  save: ->
    if @id?
      params = 
        route: "articles/#{@id}"
        body:  this._toJSON()
      Firehose.client.put( this, params )
    else
      params = 
        route: "products/#{@company.id}/articles"
        body:  this._toJSON()
      Firehose.client.post( this, params ).done (data) =>
        this._populateWithJSON data
        @product.articles().insertObject this
      
      
  destroy: ->
    params = 
      route: "articles/#{@id}"
    Firehose.client.delete( this, params ).done =>
      @product.articles().dropObject this
    

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
