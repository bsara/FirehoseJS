class FirehoseJS.Notification extends FirehoseJS.Object
    
  
  company: null
  
  title: null
  
  text: null
  
  level: 0
  
    
  @_notificationWithID: (id, company) ->
    notification = FirehoseJS.Object._objectOfClassWithID( FirehoseJS.Notification, id )
    notification.company = company
    notification 
    
    
  _populateWithJSON: (json) ->
    @title  = json.title
    @text   = json.text
    @level  = json.level
    super json