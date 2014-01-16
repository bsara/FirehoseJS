class FirehoseJS.FacebookPage extends FirehoseJS.Object
  
  
  facebookAccount: null
  
  name: null
  
  category: null
  
  pageId: null
  
  active: false
  
    
  @_facebookPageWithID: (id, facebookAccount) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.FacebookPage,
      id:              id
      facebookAccount: facebookAccount
    
    
  save: ->
    params = 
      route: "facebook_pages/#{@id}"
      body:  this._toJSON()
    FirehoseJS.client.put( params )
    
    
  _populateWithJSON: (json) ->
    this.setIfNotNull "name",     json.name
    this.setIfNotNull "category", json.category
    this.setIfNotNull "pageId",   json.page_id
    this.setIfNotNull "active",   json.active
    super json
    
    
  _toJSON: ->
    facebook_page:
      active: @active
