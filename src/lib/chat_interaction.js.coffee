class Firehose.ChatInteraction extends Firehose.Interaction


  # @nodoc
  @_firehoseType: "ChatInteraction"

  ###
  @property [date]
  ###
  readAt: null

  ###
  @property [date]
  ###
  deliveredAt: null


  # @nodoc
  @_chatInteractionWithID: (id) ->
    Firehose.Object._objectOfClassWithID Firehose.ChatInteraction,
      id: id


  # @nodoc
  _populateWithJSON: (json) ->
    if json.chat_interaction?
      chatJSON  = json.chat_interaction
      this._setIfNotNull "readAt",      chatJSON.read_at
      this._setIfNotNull "deliveredAt", chatJSON.deliveredAt

    super json
