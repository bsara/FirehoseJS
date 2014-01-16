class FirehoseJS.UniqueArray extends Array
  
  constructor: ->
    super
  
  appendObject: ->
    for arg in arguments
      if this.indexOf(arg) == -1
        this.push arg
        
  dropObject: ->
    for arg in arguments
      idx = this.indexOf arg
      this.splice( idx, 1 ) unless idx == -1
      