class FirehoseJS.Object 
  
  
  id: null

  createdAt: null
  
  @_objects: []
  
  
  constructor: (properties) ->
    for prop of properties
      this[prop] = properties[prop]
      
  
  get: (key) ->
    this[key]
  
  
  set: (key, value) ->
    this[key] = value
    
    
  setIfNotNull: (key, value) ->
    if value?
      this.set key, value
    
  
  @_objectOfClassWithID: (klass, properties) ->
    id = properties.id
    if id
      for obj in @_objects
        if obj.id and obj.id == id and obj.constructor == klass
          return obj
    obj = new klass properties
    @_objects.push obj
    obj  
    
  
  _populateAssociatedObjects: (owner, association, json, creation) ->
    if json?
      objects = new FirehoseJS.UniqueArray
      owner.set association, objects
      for objectJSON in json
        object = creation objectJSON
        object._populateWithJSON objectJSON
        objects.appendObject object
        
  
  _populateAssociatedObjectWithJSON:(owner, association, json, creation) ->
    if json? 
      object = creation json
      owner.set association, object
      object._populateWithJSON json
      
      
  _populateAssociatedObjectWithID:(owner, association, id, creation) ->
    owner.set association, if id? then creation( id ) else null
          
          
  _populateWithJSON: (json) ->
    this.setIfNotNull "id",        json.id                     unless @id?
    this.setIfNotNull "createdAt", Date.parse(json.created_at) unless @createdAt?
