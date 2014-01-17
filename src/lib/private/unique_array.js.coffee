class FirehoseJS.UniqueArray extends Array
  
  constructor: ->
    super
  
  appendObject: ->
    for arg in arguments
      if this.indexOf(arg) == -1
        this.push arg
        
  
  appendObjects: (objects) ->
    for obj in objects
      this.appendObject obj 
    
        
  dropObject: ->
    for arg in arguments
      idx = this.indexOf arg
      this.splice( idx, 1 ) unless idx == -1
      
      
  dropObjects: (objects) ->
    for obj in objects
      this.dropObject obj
