class Firehose.Attachment extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "Attachment"
  
  ###
  @property [EmailInteraction] 
  ###
  emailInteraction: null
  
  ###
  @property [String] 
  ###
  filename: null
  
  ###
  @property [String] 
  ###
  temporaryURL: null
  
    
  # @nodoc
  @_attachmentWithID: (id, emailInteraction) ->
    Firehose.Object._objectOfClassWithID Firehose.Attachment,
      id:               id
      emailInteraction: emailInteraction
    
    
  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "filename",     json.filename
    this._setIfNotNull "temporaryURL", json.temporary_url
    super json