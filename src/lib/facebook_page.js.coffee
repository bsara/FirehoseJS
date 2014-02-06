class Firehose.FacebookPage extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "FacebookPage"
  
  facebookAccount: null
  
  name: null
  
  category: null
  
  pageId: null
  
  active: false
  
    
  # @nodoc
  @_facebookPageWithID: (id, facebookAccount) ->
    Firehose.Object._objectOfClassWithID Firehose.FacebookPage,
      id:              id
      facebookAccount: facebookAccount
    
    
  save: ->
    params = 
      route: "facebook_pages/#{@id}"
      body:  this._toJSON()
    Firehose.client.put( params )
    
    
  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "name",     json.name
    this._setIfNotNull "category", json.category
    this._setIfNotNull "pageId",   json.page_id
    this._setIfNotNull "active",   json.active
    super json
    
    
  # @nodoc
  _toJSON: ->
    facebook_page:
      active: @active
