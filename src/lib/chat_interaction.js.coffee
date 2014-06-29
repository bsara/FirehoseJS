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
  deliveredTime: null

  ###
  @property [Date]
  ###
  readTime: null

  ###
  @property [Date]
  ###
  editedTime: null

  ###
  @property [Date]
  ###
  failedTime: null

  ###
  @property [String]
  ###
  senderDisplayName: null

  ###
  @property [Firehose.ChatInteractionKind]
  ###
  kind: null


  # @nodoc
  @_chatInteractionWithID: (id) ->
    Firehose.Object._objectOfClassWithID Firehose.ChatInteraction,
      id: id


  ###
  @param json [JSON Object]
  @param visitor [Firhose.Visitor]
  @return [Firehose.ChatInteraction] The chat interaction object that was created.
  ###
  @chatInteractionWithJSON: (json, visitor) ->
    chatInteraction = Firehose.ChatInteraction._chatInteractionWithID json.id
    chatInteraction.visitor = visitor
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
      @_setIfNotNull "deliveredTime",     @_date chatJSON.delivered_at
      @_setIfNotNull "readTime",          @_date chatJSON.read_at
      @_setIfNotNull "editedTime",        @_date chatJSON.edited_at
      @_setIfNotNull "failedTime",        @_date chatJSON.failed_at
      @_setIfNotNull "senderDisplayName", chatJSON.sender_display_name
      @_setIfNotNull "kind",              chatJSON.kind

      @_populateAssociatedObjectWithJSON this, "visitor", chatJSON.visitor, (json) ->
        Firehose.Visitor.visitorWithID json.id

    super json


