class Firehose.ChatInteraction extends Firehose.Interaction


  # @nodoc
  @_firehoseType: "ChatInteraction"

  ###
  @property [Firehose.Visitor]
  ###
  visitor: null

  ###
  @propety [Firehose.Agent]
  ###
  agent: null

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
    chatInteraction = Firehose.ChatInteraction.chatInteractionWithID json.id, visitor
    chatInteraction._populateWithJSON json
    chatInteraction


  # @nodoc
  getNewMessageJSON: ->
    json =
      message_id : @get 'id'
      body       : @get 'body'
      kind       : @get 'kind'

    agent = @get('agent')
    if agent?
      json.visitor_id = @get('visitor')?.get 'id'
      json.agent =
        id           : agent.get 'id'
        display_name : @get 'senderDisplayName'
    else
      # TODO: Implement once it is needed

    json




  # @nodoc
  _populateWithJSON: (json) ->
    chatJSON = if json.chat_interaction? then json.chat_interaction else json

    @_setIfNotNull 'deliveredAt',       @_date chatJSON.delivered_at
    @_setIfNotNull 'readAt',            @_date chatJSON.read_at
    @_setIfNotNull 'editedAt',          @_date chatJSON.edited_at
    @_setIfNotNull 'failedAt',          @_date chatJSON.failed_at
    @_setIfNotNull 'senderDisplayName', chatJSON.sender_display_name
    @_setIfNotNull 'kind',              chatJSON.kind
    @_setIfNotNull 'agent',             Firehose.Agent.agentWithID(chatJSON.agent_id, @visitor.company) if chatJSON.agent_id?

    super json


