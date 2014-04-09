class Firehose.EmailInteraction extends Firehose.Interaction


  # @nodoc
  @_firehoseType: "EmailInteraction"

  ###
  @property [EmailAccount]
  ###
  emailAccount: null

  ###
  @property [string]
  ###
  emailSubject: null

  ###
  @property [string]
  ###
  replyTo: null

  ###
  @property [string]
  ###
  toEmail: null

  ###
  @property [string]
  ###
  fromEmail: null

  # associations

  ###
  @property [Array<Attachment>]
  ###
  attachments: null


  # @nodoc
  _setup: ->
    @attachments = new Firehose.UniqueArray


  # @nodoc
  @_emailInteractionWithID: (id) ->
    Firehose.Object._objectOfClassWithID Firehose.EmailInteraction,
      id: id


  ###
  Returns the URL to the source of the email interaction exactly as it was received into Firehose.
  @note: You can only call this on an e-mail interaction.
  @return [String] A full URL to the email's raw RFC source.
  ###
  linkToSource: ->
    "#{Firehose.baseURLFor('API')}/interactions/#{@token}/raw_source"


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

