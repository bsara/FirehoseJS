class FirehoseJS.RemoteArray extends FirehoseJS.UniqueArray
  
  
  perPage: -1
  
  page: 1
  
  totalRows: 0
  
  _path: null
  
  _params: null
  
  _creationFunction: null
  
  _fetchingFunction: null
  
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
          for json in data
            object = @_creationFunction(json)
            object._populateWithJSON json
            this.appendObject object
      
      
  isAllLoaded: ->
   this.length == @totalRows 
   
    
  next: ->
    return null if not @_fresh and this.length == @totalRows
    @_fresh = false
    @_fetchingFunction( @page++ )
  
  
  empty: ->
    for obj in this.splice(0)
      this.dropObject obj
    
  
  reset: ->
    this.empty()
    @totalRows  = 0
    @_fresh     = true
    @page       = 1
    
    
  
  