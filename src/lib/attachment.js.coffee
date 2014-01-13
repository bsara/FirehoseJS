class FirehoseJS.Attachment extends FirehoseJS.Object
  
  
  emailInteraction: null
  
  filename: null
  
  temporaryURL: null
  
    
  @_attachmentWithID: (id, emailInteraction) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Attachment,
      id:               id
      emailInteraction: emailInteraction
    
    
  _populateWithJSON: (json) ->
    @filename     = json.filename
    @temporaryURL = json.temporary_url
    super json