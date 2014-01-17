class FirehoseJS.UniqueArray extends Array
  
  
  _sortOn: null
  
  _sortDirection: 'asc'
  
  
  constructor: ->
    super
  
  
  appendObject: ->
    for arg in arguments
      if this.indexOf(arg) == -1
        this.push arg
        
  
  appendObjects: (objects) ->
    for obj in objects
      this.appendObject obj
    
    
  insertObject: ->
    this.appendObject.apply this, arguments
    this.sortObjects()
    
    
  insertObjects: (objects) -> 
    this.appendObjects objects
    this.sortObjects()
    
        
  dropObject: ->
    for arg in arguments
      idx = this.indexOf arg
      this.splice( idx, 1 ) unless idx == -1
      
      
  dropObjects: (objects) ->
    for obj in objects
      this.dropObject obj


  sortOn: (property, direction) ->
    @_sortOn        = property
    @_sortDirection = direction || 'asc'


  sortObjects: ->
    return unless @_sortOn?
    this.sort (obj1, obj2) =>
      if @_sortDirection == 'asc'
        obj1[@_sortOn] > obj2[@_sortOn]
      else
        obj1[@_sortOn] < obj2[@_sortOn]