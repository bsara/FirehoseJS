class FirehoseJS.RemoteArray extends FirehoseJS.UniqueArray
  
  
  perPage: -1
  
  page: 1
  
  totalRows: 0
  
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
  
  
  constructor: (path, params, creationFunction) ->
    @_path              = path
    @_params            = params || {}
    @_creationFunction  = creationFunction
    @_fetchingFunction  = (page) =>
      options = 
        route:    @_path
        params:   @_params
        page:     page
        perPage:  @perPage
      FirehoseJS.client.get( options ).done (data) =>
        if data.constructor == Array and data.length > 0
          @totalRows = data[0].total_rows
          aggregate = []
          for json in data
            object = @_creationFunction(json)
            object._populateWithJSON json
            aggregate.push object
          this.insertObjects aggregate 
      
      
  isAllLoaded: ->
    not @_fresh and parseInt(this.length) == parseInt(@totalRows)
   
    
  next: ->
    return null if not @_fresh and this.length == @totalRows
    @_fresh = false
    @_fetchingFunction( @page++ )
  
  
  empty: ->
    this.dropObjects this.splice(0)
    
  
  reset: ->
    this.empty()
    @totalRows  = 0
    @_fresh     = true
    @page       = 1
    
    
  
  