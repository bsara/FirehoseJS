class FirehoseJS.EmailInteraction extends FirehoseJS.Interaction

  
  emailSubject: null
  
  replyTo: null
  
  toEmail: null
  
  fromEmail: null
  
  # associations
  
  attachments: new FirehoseJS.UniqueArray
    
    
  @_emailInteractionWithID: (id) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.EmailInteraction,
      id: id
    
  
  _populateWithJSON: (json) ->
    if json.email_interaction?
      emailJSON     = json.email_interaction
      this.set "emailSubject", emailJSON.subject
      this.set "replyTo",      emailJSON.reply_to
      this.set "toEmail",      emailJSON.to_email
      this.set "fromEmail",    emailJSON.from_email
    
      this._populateAssociatedObjects this, "attachments", emailJSON.attachments, (json) =>
        FirehoseJS.Attachment._attachmentWithID( json.id, this )
      
    super json
  
