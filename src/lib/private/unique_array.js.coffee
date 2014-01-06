class FirehoseJS.UniqueArray extends Array
  
  
  constructor: ->
    super
  
  push: ->
    for arg in arguments
      if this.indexOf(arg) == -1
        super arg
        
  unshift: ->
    for arg in arguments
      if this.indexOf(arg) == -1
        super arg
        
  remove: (obj) ->
    idx = this.indexOf obj
    this.splice( idx, 1 ) unless idx == -1