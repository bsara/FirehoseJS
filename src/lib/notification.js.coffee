class Firehose.Notification extends Firehose.Object
    
  
  # @nodoc
  @_firehoseType: "Notification"
  
  company: null
  
  title: null
  
  text: null
  
  level: 0
  
    
  # @nodoc
  @_notificationWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.Notification,
      id:      id
      company: company
    
    
  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "title", json.title
    this._setIfNotNull "text",  json.text
    this._setIfNotNull "level", json.level
    super json