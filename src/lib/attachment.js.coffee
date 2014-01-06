class FirehoseJS.Attachment extends FirehoseJS.Object
  
  
  emailInteraction: null
  
  filename: null
  
  temporaryURL: null
  
  
  constructor: (id, emailInteraction) ->
    @id               = id
    @emailInteraction = emailInteraction
    
    
  _populateWithJSON: (json) ->
    @filename     = json.filename
    @temporaryURL = json.temporary_url
    super json