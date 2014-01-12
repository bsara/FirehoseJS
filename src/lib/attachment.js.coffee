class FirehoseJS.Attachment extends FirehoseJS.Object
  
  
  emailInteraction: null
  
  filename: null
  
  temporaryURL: null
  
    
  @_attachmentWithID: (id, emailInteraction) ->
    attachment = FirehoseJS.Object._objectOfClassWithID( FirehoseJS.Attachment, id )
    attachment.emailInteraction = emailInteraction
    attachment 
    
    
  _populateWithJSON: (json) ->
    @filename     = json.filename
    @temporaryURL = json.temporary_url
    super json