class FirehoseJS.EmailInteraction extends FirehoseJS.Interaction

  
  emailSubject: null
  
  replyTo: null
  
  toEmail: null
  
  fromEmail: null
  
  # associations
  
  attachments: null
    
    
  setup: ->
    @attachments = new FirehoseJS.UniqueArray
    
    
  @_emailInteractionWithID: (id) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.EmailInteraction,
      id: id
    
  
  _populateWithJSON: (json) ->
    if json.email_interaction?
      emailJSON     = json.email_interaction
      this.setIfNotNull "emailSubject", emailJSON.subject
      this.setIfNotNull "replyTo",      emailJSON.reply_to
      this.setIfNotNull "toEmail",      emailJSON.to_email
      this.setIfNotNull "fromEmail",    emailJSON.from_email
    
      this._populateAssociatedObjects this, "attachments", emailJSON.attachments, (json) =>
        FirehoseJS.Attachment._attachmentWithID( json.id, this )
      
    super json
  
