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
  @property [Array<String>] The errors the server returned about fields that did not contain valid values.
  ###
  errors: []

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
  set: (key, value, checkIfIsEmber = true) ->
    this[key] = value


  ###
  Uses the classes 'archivableProperties' to stringify this object and save it in localStorage.
  @param key [String] an optional key to archive the object by if the 'id' is not available.
  ###
  archive: (key = @id) ->
    index = "#{@constructor._firehoseType}_#{key}"
    localStorage[index] = JSON.stringify @_toArchivableJSON()


  ###
  Unarchives the object from local storage.
  @param key [String] an optional key to unarchive the object by if 'id' is not available.
  @return [boolean] true if the object was in localStorage, false if it was not.
  ###
  unarchive: (key = @id) ->
    index = "#{@constructor._firehoseType}_#{key}"
    if localStorage[index]?
      json = $.parseJSON localStorage[index]
      @_populateWithJSON json
      true
    else
      false


  ###
  Clears all data from the `errors` array.
  ###
  clearErrors: ->
    @set "errors", []


  ###
  Takes the `errors` property and formats it's items for display in HTML.
  @return [String] An HTML marked-up version of the `errors` property in the form of an unordered list (<ul>).
  ###
  HTMLErrorString: ->
    HTML = "<ul>"
    lines = @errors
    if lines?
      for line in lines
        HTML += "<li>#{line}</li>"
    HTML += "</ul>"
    HTML


  ###
  Checks if the Object has been converted into an "Ember object".
  @return [boolean] Whether or not the object is an Ember object.
  ###
  isEmberObject: ->
    `for (attr in this) {
      if (attr.indexOf('__') != 0) {
        continue;
      }
      return (attr.search(/__ember\d[^_]+?_meta/i) >= 0);
    }`
    return false



  # private

  ###
  Create an object to be cached
  @nodoc
  ###
  @_objectOfClassWithID: (klass, properties) ->
    properties.id = parseInt properties.id unless isNaN properties.id
    if properties.id
      for obj in @_objects
        if obj.id and obj.id == properties.id and obj.constructor._firehoseType == klass._firehoseType
          return obj
    obj = new klass properties
    obj._setup()
    @_objects.push obj
    obj


  # @nodoc
  _populateAssociatedObjects: (owner, association, json, creation) ->
    if json?
      objects = new Firehose.UniqueArray
      for objectJSON in json
        object = creation objectJSON
        object._populateWithJSON objectJSON
        objects.push object
      owner.set association, objects


  # @nodoc
  _populateAssociatedObjectWithJSON:(owner, association, json, creation) ->
    if json?
      object = creation json
      owner.set association, object
      object._populateWithJSON json


  # @nodoc
  _populateAssociatedObjectWithID:(owner, association, id, creation) ->
    owner.set association, if id? then creation id else null


  # @nodoc
  _populateWithJSON: (json) ->
    @_setIfNotNull "id",        json.id                unless @id?
    @_setIfNotNull "createdAt", @_date json.created_at


  # @nodoc
  _setIfNotNull: (key, value) ->
    if value?
      @set key, value


  # @nodoc
  _toArchivableJSON: ->
    id:         @id
    created_at: @createdAt


  # @nodoc
  _textOrNull: (value) ->
    return if !value?
    if value.length > 0 then value else null


  # @nodoc
  _date: (dateString) ->
    return null if !dateString? || dateString.trim().length == 0

    if dateString.trim().match /^\d{4}-\d{2}-\d{2} \d{1,2}:\d{2}:\d{2}$/g
      dateString += " UTC"

    date = new Date dateString
    if isNaN date then null else date





