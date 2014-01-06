class FirehoseJS.EmailInteraction extends FirehoseJS.Interaction

  
  emailSubject: null
  
  replyTo: null
  
  toEmail: null
  
  fromEmail: null
  
  # associations
  
  attachments: new FirehoseJS.UniqueArray
 
  
  constructor: (id) ->
    @id = id
  
  
  _populateWithJSON: (json) ->
    emailJSON     = json.email_interaction
    @emailSubject = emailJSON.subject
    @replyTo      = emailJSON.reply_to
    @toEmail      = emailJSON.to_email
    @fromEmail    = emailJSON.from_email
    
    this._populateAssociatedObjects this, "attachments", emailJSON.attachments, (json) =>
      new FirehoseJS.Attachment( json.id, this )
      
    super json
  