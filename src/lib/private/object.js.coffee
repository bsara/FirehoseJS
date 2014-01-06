class FirehoseJS.Object 
  
  
  id: null

  createdAt: null
  
  
  _populateAssociatedObjects: (owner, association, json, creation) ->
    if json?
      objects = owner[association] = new FirehoseJS.UniqueArray
      for objectJSON in json
        object = creation objectJSON
        object._populateWithJSON objectJSON
        objects.push object
        
  
  _populateAssociatedObjectWithJSON:(owner, association, json, creation) ->
    if json? 
      object = owner[association] = creation json
      object._populateWithJSON json
      
      
  _populateAssociatedObjectWithID:(owner, association, id, creation) ->
    owner[association] = if id? then creation( id ) else null
          
          
  _populateWithJSON: (json) ->
    @id         ?= json.id
    @createdAt  ?= Date.parse json.created_at
  