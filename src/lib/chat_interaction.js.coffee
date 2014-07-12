class Firehose.ChatInteraction extends Firehose.Interaction


  # @nodoc
  @_firehoseType: "ChatInteraction"

  ###
  @property [Firehose.Visitor]
  ###
  visitor: null

  ###
  @property [Date]
  ###
  deliveredAt: null

  ###
  @property [Date]
  ###
  readAt: null

  ###
  @property [Date]
  ###
  editedAt: null

  ###
  @property [Date]
  ###
  failedAt: null

  ###
  @property [String]
  ###
  senderDisplayName: null

  ###
  If null, then the sender is the chat interaction's visitor
  @property [Number]
  ###
  senderId: null

  ###
  @property [boolean]
  ###
  isSenderAnAgent: false

  ###
  @property [Firehose.ChatInteractionKind]
  ###
  kind: null


  ###
  Create a chat interaction by ID so you can fetch its info from the api server.
  @param id [Number] The ID of the chat interaction you wish to retrieve.
  @param visitor [Firhose.Visitor] The visitor that contains the chat interaction being created.
  ###
  @chatInteractionWithID: (id, visitor) ->
    Firehose.Object._objectOfClassWithID Firehose.ChatInteraction,
      id      : id
      visitor : visitor


  ###
  @param json [JSON Object]
  @param visitor [Firhose.Visitor]
  @return [Firehose.ChatInteraction] The chat interaction object that was created.
  ###
  @chatInteractionWithJSON: (json, visitor) ->
    chatInteraction = Firehose.ChatInteraction.chatInteractionWithID json.id, visitor
    chatInteraction._populateWithJSON json
    chatInteraction


  ###
  @param body [String]
  @param agent [Firehose.Agent]
  @return [Firehose.ChatInteraction] The chat interaction object that was created.
  ###
  @chatInteractionWithBody: (body, visitor) ->
    # TODO: Implement
    null



  # @nodoc
  _populateWithJSON: (json) ->
    chatJSON = if json.chat_interaction? then json.chat_interaction else json

    @set           'deliveredAt',       @_date chatJSON.delivered_at if chatJSON.delivered_at?
    @set           'readAt',            @_date chatJSON.read_at      if chatJSON.read_at?
    @set           'editedAt',          @_date chatJSON.edited_at    if chatJSON.edited_at?
    @set           'failedAt',          @_date chatJSON.failed_at    if chatJSON.failed_at?
    @_setIfNotNull 'senderDisplayName', chatJSON.sender_display_name
    @_setIfNotNull 'senderId',          chatJSON.sender_id
    @_setIfNotNull 'isSenderAnAgent',   chatJSON.sender_is_agent
    @_setIfNotNull 'kind',              chatJSON.kind

    super json


