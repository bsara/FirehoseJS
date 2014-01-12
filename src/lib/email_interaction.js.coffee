class FirehoseJS.EmailInteraction extends FirehoseJS.Interaction

  
  emailSubject: null
  
  replyTo: null
  
  toEmail: null
  
  fromEmail: null
  
  # associations
  
  attachments: new FirehoseJS.UniqueArray
    
    
  @_emailInteractionWithID: (id) ->
    FirehoseJS.Object._objectOfClassWithID( FirehoseJS.EmailInteraction, id )
    
  
  _populateWithJSON: (json) ->
    if json.email_interaction?
      emailJSON     = json.email_interaction
      @emailSubject = emailJSON.subject
      @replyTo      = emailJSON.reply_to
      @toEmail      = emailJSON.to_email
      @fromEmail    = emailJSON.from_email
    
      this._populateAssociatedObjects this, "attachments", emailJSON.attachments, (json) =>
        FirehoseJS.Attachment._attachmentWithID( json.id, this )
      
    super json
  