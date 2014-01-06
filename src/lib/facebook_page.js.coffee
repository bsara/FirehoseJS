class FirehoseJS.FacebookPage extends FirehoseJS.Object
  
  
  facebookAccount: null
  
  name: null
  
  category: null
  
  pageId: null
  
  active: false
  
  
  construction: (id, facebookAccount) ->
    @id               = id
    @facebookAccount  = facebookAccount
    
    
  save: ->
    params = 
      route: "facebook_pages/#{@id}"
      body:  this._toJSON()
    FirehoseJS.client.put( params )
    
    
  _populateWithJSON: (json) ->
    @name     = json.name
    @category = json.category
    @pageId   = json.page_id
    @active   = json.active
    super json
    
    
  _toJSON: ->
    facebook_page:
      active: @active
