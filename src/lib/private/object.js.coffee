# Base class for Firehose API Objects
class Firehose.Object 
  
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
  @note You never need to construct a `Firehose.Object` object directly. Use a subclass' factory method.
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
  @note A client-side library that uses observers often uses get/set methods. You can do `Firehose.Object.set = Ember.Object.set` for example.
  ###
  get: (key) ->
    this[key]
  
  ###
  A placeholder for third-party libraries to replace. (e.g Ember.js, Backbone.js)
  @note A client-side library that uses observers often uses get/set methods. You can do `Firehose.Object.get = Ember.Object.get` for example.
  ###
  set: (key, value) ->
    this[key] = value
    
  ###
  Uses the classes 'archivableProperties' to stringify this object and save it in localStorage.
  @param key [string] an optional key to archive the object by if the 'id' is not available.
  ###
  archive: (key = @id) ->
    index = "#{this.constructor._firehoseType}_#{key}"
    localStorage[index] = JSON.stringify this._toArchivableJSON()
    
  ###
  Unarchives the object from local storage.
  @param key [string] an optional key to unarchive the object by if 'id' is not available.
  @return [boolean] true if the object was in localStorage, false if it was not.
  ###
  unarchive: (key = @id) ->
    index = "#{this.constructor._firehoseType}_#{key}"
    if localStorage[index]?
      json = $.parseJSON localStorage[index]
      this._populateWithJSON json
      true
    else
      false
    
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
      objects = new Firehose.UniqueArray
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
      
  # @nodoc
  _toArchivableJSON: ->
    id:         @id
    created_at: @createdAt
    
