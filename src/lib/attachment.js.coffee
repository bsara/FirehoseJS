class FirehoseJS.Attachment extends FirehoseJS.Object
  
  
  @firehoseType: "Attachment"
  
  emailInteraction: null
  
  filename: null
  
  temporaryURL: null
  
    
  @_attachmentWithID: (id, emailInteraction) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Attachment,
      id:               id
      emailInteraction: emailInteraction
    
    
  _populateWithJSON: (json) ->
    this.setIfNotNull "filename",     json.filename
    this.setIfNotNull "temporaryURL", json.temporary_url
    super json