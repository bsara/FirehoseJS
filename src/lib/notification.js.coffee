class FirehoseJS.Notification extends FirehoseJS.Object
    
  
  firehoseType: "Notification"
  
  company: null
  
  title: null
  
  text: null
  
  level: 0
  
    
  @_notificationWithID: (id, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Notification,
      id:      id
      company: company
    
    
  _populateWithJSON: (json) ->
    this.setIfNotNull "title", json.title
    this.setIfNotNull "text",  json.text
    this.setIfNotNull "level", json.level
    super json