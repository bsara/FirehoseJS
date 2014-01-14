class FirehoseJS.Attachment extends FirehoseJS.Object
  
  
  emailInteraction: null
  
  filename: null
  
  temporaryURL: null
  
    
  @_attachmentWithID: (id, emailInteraction) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Attachment,
      id:               id
      emailInteraction: emailInteraction
    
    
  _populateWithJSON: (json) ->
    this.set "filename",     json.filename
    this.set "temporaryURL", json.temporary_url
    super json