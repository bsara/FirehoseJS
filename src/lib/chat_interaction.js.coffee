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
    chatInteraction = Firehose.ChatInteraction._chatInteractionWithID json.id, visitor
    chatInteraction._populateWithJSON json
    chatInteraction


  ###
  @param body [String]
  @param agent [Firehose.Agent]
  @return [Firehose.ChatInteraction] The chat interaction object that was created.
  ###
  @chatInteractionWithBody: (body, agent) ->
    # TODO: Implement
    null


  # @nodoc
  _populateWithJSON: (json) ->
    if json.chat_interaction?
      chatJSON = json.chat_interaction
      @_setIfNotNull "deliveredAt",       @_date chatJSON.delivered_at
      @_setIfNotNull "readAt",            @_date chatJSON.read_at
      @_setIfNotNull "editedAt",          @_date chatJSON.edited_at
      @_setIfNotNull "failedAt",          @_date chatJSON.failed_at
      @_setIfNotNull "senderDisplayName", chatJSON.sender_display_name
      @_setIfNotNull "kind",              chatJSON.kind
    super json


