# @nodoc
class Firehose.UniqueArray extends Array


  _sortOn: null

  _sortDirection: 'asc'


  constructor: ->
    super


  appendObject: ->
    for arg in arguments
      if @indexOf(arg) == -1
        @push arg


  appendObjects: (objects) ->
    for obj in objects
      @appendObject obj


  insertObject: ->
    @appendObject.apply this, arguments
    @sortObjects()


  insertObjects: (objects) ->
    @appendObjects objects
    @sortObjects()


  dropObject: ->
    for arg in arguments
      idx = @indexOf arg
      @splice( idx, 1 ) unless idx == -1


  dropObjects: (objects) ->
    for obj in objects
      @dropObject obj


  sortOn: (property, direction) ->
    @_sortOn        = property
    @_sortDirection = direction || 'asc'


  sortObjects: ->
    return unless @_sortOn?
    @sort (obj1, obj2) =>
      return  1 if obj1[@_sortOn] > obj2[@_sortOn]
      return -1 if obj1[@_sortOn] < obj2[@_sortOn]
      return  0
    `if (this._sortDirection === 'desc') {
      this.reverse();
    }`
    #@reverse() if @_sortDirection == 'desc'
    return


  # @nodoc
  _toArchivableJSON: ->
    archiveArray = []
    for obj in this
      archiveArray.push obj._toArchivableJSON()
    archiveArray

