class Firehose.RemoteArray extends Firehose.UniqueArray
  
  
  ###
  @property [integer] 
  ###
  perPage: -1
  
  ###
  @property [integer] 
  ###
  page: 1
  
  ###
  @property [boolean] 
  ###
  auth: true
  
  ###
  @property [integer] 
  ###
  totalRows: 0
  
  ###
  @property [Object] query params you only want sent on the first `next()` call.
  ###
  onceParams: null
  
  # @nodoc
  _path: null
  
  # @nodoc
  _params: null
  
  # @nodoc
  _creationFunction: null
  
  # @nodoc
  _fetchingFunction: null
  
  # @nodoc
  _fresh: true
  
  # @nodoc
  @_currentXHR: null
  
  
  # @nodoc
  constructor: (path, params = {}, creationFunction) ->
    @_path              = path
    @_params            = params
    @_creationFunction  = creationFunction
    @_fetchingFunction  = (page) =>
      options = 
        route:    @_path
        auth:     @auth
        params:   if @onceParams then $.extend( @onceParams, @_params ) else @_params
        page:     page
        perPage:  @perPage
      @onceParams = null
      @_currentXHR = Firehose.client.get( options ).done (data) =>
        if data.constructor == Array and data.length > 0
          @totalRows = data[0].total_rows
          aggregate = []
          for json in data
            object = @_creationFunction(json)
            object._populateWithJSON json
            aggregate.push object
          this.insertObjects aggregate 
      .always =>
        @_currentXHR = null
        
      
  isAllLoaded: ->
    not @_fresh and parseInt(this.length) == parseInt(@totalRows)
   
    
  next: ->
    return null if not @_fresh and this.length == @totalRows
    @_fresh = false
    @_fetchingFunction( @page++ )
  
  
  abort: ->
    @_currentXHR?.abort() 
  
  
  empty: ->
    this.dropObjects this.splice(0)
    
    
  reset: ->
    this.empty()
    @totalRows  = 0
    @_fresh     = true
    @page       = 1
    
    
  
  