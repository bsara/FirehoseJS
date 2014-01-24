# Base class for FirehoseJS API Objects
class FirehoseJS.Object 
  
  ###
  @property [Number] Unique ID of object
  ###
  id: null

  ###
  @property [Date] When the object was created on the server
  ###
  createdAt: null
  
  ###
  @property [Array<Object>] The static array that holds the entire object graph
  @nodoc
  ###
  @_objects: []
  
  
  ###
  @note You never need to construct a `FirehoseJS.Object` object directly. Use a subclass' factory method.
  @private
  ###
  constructor: (properties) ->
    for prop of properties
      this[prop] = properties[prop]
      
  
  ###
  To be overridden by subclasses
  @nodoc 
  ###
  _setup: ->
    
  ###
  A placeholder for third-party libraries to replace. (e.g Ember.js, Backbone.js)
  @note A client-side library that uses observers often uses get/set methods. You can do `FirehoseJS.Object.set = Ember.Object.set` for example.
  ###
  get: (key) ->
    this[key]
  
  ###
  A placeholder for third-party libraries to replace. (e.g Ember.js, Backbone.js)
  @note A client-side library that uses observers often uses get/set methods. You can do `FirehoseJS.Object.get = Ember.Object.get` for example.
  ###
  set: (key, value) ->
    this[key] = value
    
    
  ###
  Create an object to be cached
  
  @nodoc
  ###
  @_objectOfClassWithID: (klass, properties) ->
    parsedID = parseInt properties.id
    properties.id = parsedID unless isNaN parsedID
    if parsedID
      for obj in @_objects
        if obj.id and obj.id == parsedID and obj.constructor._firehoseType == klass._firehoseType
          return obj
    obj = new klass properties
    obj._setup()
    @_objects.push obj
    obj  
    
  
  # @nodoc
  _populateAssociatedObjects: (owner, association, json, creation) ->
    if json?
      objects = new FirehoseJS.UniqueArray
      owner.set association, objects
      aggregate = []
      for objectJSON in json
        object = creation objectJSON
        object._populateWithJSON objectJSON
        aggregate.push object
      objects.insertObjects aggregate 
        
  
  # @nodoc
  _populateAssociatedObjectWithJSON:(owner, association, json, creation) ->
    if json? 
      object = creation json
      owner.set association, object
      object._populateWithJSON json
      
      
  # @nodoc
  _populateAssociatedObjectWithID:(owner, association, id, creation) ->
    owner.set association, if id? then creation( id ) else null
          
          
  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "id",        json.id                     unless @id?
    this._setIfNotNull "createdAt", Date.parse(json.created_at) unless @createdAt?

  # @nodoc
  _setIfNotNull: (key, value) ->
    if value?
      this.set key, value
    
  
