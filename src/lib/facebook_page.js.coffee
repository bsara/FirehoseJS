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
    this.set "name",     json.name
    this.set "category", json.category
    this.set "pageId",   json.page_id
    this.set "active",   json.active
    super json
    
    
  _toJSON: ->
    facebook_page:
      active: @active
