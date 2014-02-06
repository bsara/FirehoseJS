class Firehose.EmailInteraction extends Firehose.Interaction


  # @nodoc
  @_firehoseType: "EmailInteraction"
  
  emailSubject: null
  
  replyTo: null
  
  toEmail: null
  
  fromEmail: null
  
  # associations
  
  attachments: null
    
    
  # @nodoc
  _setup: ->
    @attachments = new Firehose.UniqueArray
    
    
  # @nodoc
  @_emailInteractionWithID: (id) ->
    Firehose.Object._objectOfClassWithID Firehose.EmailInteraction,
      id: id
    
  
  # @nodoc
  _populateWithJSON: (json) ->
    if json.email_interaction?
      emailJSON     = json.email_interaction
      this._setIfNotNull "emailSubject", emailJSON.subject
      this._setIfNotNull "replyTo",      emailJSON.reply_to
      this._setIfNotNull "toEmail",      emailJSON.to_email
      this._setIfNotNull "fromEmail",    emailJSON.from_email
    
      this._populateAssociatedObjects this, "attachments", emailJSON.attachments, (json) =>
        Firehose.Attachment._attachmentWithID( json.id, this )
        
      this._populateAssociatedObjectWithJSON this, "emailAccount", emailJSON.email_account, (json) ->
        Firehose.EmailAccount._emailAccountWithID( json.id )
      
    super json
  
