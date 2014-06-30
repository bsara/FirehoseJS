class Firehose.Visitor extends Firehose.Object


  # @nodoc
  @_firehoseType: "Visitor"

  ###
  @property [Firehose.Company]
  ###
  company: null

  ###
  @property [String]
  ###
  email: null

  ###
  @property [String]
  ###
  name: null

  ###
  @property [String]
  ###
  avatarURL: null

  ###
  @property [String]
  ###
  location: null

  ###
  @property [Number]
  ###
  locationLongitude: null

  ###
  @property [Number]
  ###
  locationLatitude: null

  ###
  @property [???]
  ###
  timeZone: null

  ###
  @property [String]
  ###
  referringURL: null

  ###
  @property [Date]
  ###
  connectedAt: null

  ###
  @property [Date]
  ###
  disconnectedAt: null

  ###
  @property [String]
  ###
  currentURL: null

  ###
  @property [String]
  ###
  ipAddress: null

  ###
  @property [Dictionary]
  ###
  customAttributes: null

  ###
  @property [Date]
  ###
  visitedCurrentURLAt: null

  ###
  @property [Firehose.VisitorBoxState]
  ###
  boxState: Firehose.VisitorBoxState.NONE

  ###
  @property [String]
  ###
  mostRecentChat: null

  ###
  @property [Date]
  ###
  mostRecentChatReceivedAt: null

  ###
  @property [String]
  ###
  browserName: null

  ###
  @property [String]
  ###
  browserVersion: null

  ###
  @property [String]
  ###
  browserMajor: null

  ###
  @property [String]
  ###
  operatingSystemName: null

  ###
  @property [String]
  ###
  operatingSystemVersion: null

  ###
  @property [String]
  ###
  deviceModel: null

  ###
  @property [String]
  ###
  deviceType: null

  ###
  @property [String]
  ###
  deviceVendor: null

  ###
  @property [boolean]
  ###
  needsResponse: false

  ###
  @property [boolean]
  ###
  isOnline: false

  ###
  @property [Array]
  ###
  typers: null

  # remote arrays

  # @nodoc
  _chatInteractions: null


  # @nodoc
  _setup: ->
    @typers = new Firehose.UniqueArray


  ###
  Create a visitor by ID so you can fetch its info and chat history from the api server.
  @param id [Number] The ID of the visitor you wish to retrieve.
  @return [Firehose.Visitor] The visitor object that was created.
  ###
  @visitorWithID: (id) ->
    Firehose.Object._objectOfClassWithID Firehose.Visitor,
      id: id


  ###
  Create a visitor from JSON pushed through the chat server socket connection.
  @param json [JSON Object]
  @param company [Firehose.Company]
  @return [Firehose.Visitor] The visitor object that was created.
  ###
  @visitorWithJSON: (json, company) ->
    visitor = Firehose.Visitor.visitorWithID json.id
    visitor.company = company
    visitor


  ###
  Fetch information about this visitor that was archived to the api server by the chat
  server based on its ID.
  @return [jqXHR Promise] Promise
  ###
  fetch: ->
    # TODO: Implement
    null


  ###
  The chat interactions of the visitor.
  @return [Firehose.RemoteArray<Firehose.ChatInteraction>] The found chat interactions.
  ###
  chatInterations: ->
    unless @_chatInteractions?
      @_setIfNotNull '_chatInteractions', new Firehose.RemoteArray "visitors/#{@id}/chat_interactions", null, (json) =>
        Firehose.ChatInteraction.chatInteractionWithJSON json, this
      @_chatInteractions.sortOn 'deliveredAt'
    @_chatInteractions


  ###
  When you first load a visitor and you have a lot of interactions you don't want to
  add one-by-one this is the best way to add them all at once so the interface doesn't
  animate the addition of each one.
  @param chatInteractions [Array<Firehose.ChatInteraction>]
  ###
  addChatInteractions: (chatInteractions) ->
    # TODO: Implement
    return


  ###
  @return [String] The location if the display name is not a real human name.
  ###
  getPreferredDisplayName: ->
    # TODO: Implement
    null


  ###
  @return [Firehose.ChatInteraction] Only available if chats have been fetched for this visitor.
  ###
  getMostRecentChatInteraction: ->
    # TODO: Implement
    null


  ###
  Used when the chat server sends update information.
  @param json [JSON Object]
  ###
  updateWithJSON: (json) ->
    # TODO: Implement


  ###
  Adds a typer.
  @param typer [Firehose.Object]
  ###
  addTyper: (typer) ->
    # TODO: Implement


  ###
  Removes a typer.
  @param typer [Firehose.Object]
  ###
  removeTyper: (typer) ->
    # TODO: Implement


  # @nodoc
  _populateWithJSON: (json) ->
    @_setIfNotNull 'email',                    json.email
    @_setIfNotNull 'name',                     json.raw_name
    @_setIfNotNull 'avatarURL',                json.avatar_url
    @_setIfNotNull 'location',                 json.location
    @_setIfNotNull 'locationLongitude',        json.longitude
    @_setIfNotNull 'locationLatitude',         json.latitude
    # TODO: How to handle timeZone???
    #@_setIfNotNull 'timeZone',                 json.time_zone
    @_setIfNotNull 'referringURL',             json.referrer_url
    @_setIfNotNull 'connectedAt',              @_date json.connected_at
    @_setIfNotNull 'disconnectedAt',           @_date json.disconnected_at
    @_setIfNotNull 'currentURL',               json.current_url
    @_setIfNotNull 'ipAddress',                json.ip

    # TODO: what to do with custom_attributes???
    #@_setIfNotNull 'customAttributes',         json.custom_attributes

    @_setIfNotNull 'visitedCurrentURLAt',      @_date json.visited_current_url_at

    @_setIfNotNull 'boxState',                 json.box_state

    @_setIfNotNull 'mostRecentChat',           json.most_recent_chat
    @_setIfNotNull 'mostRecentChatReceivedAt', @_date json.most_recent_chat_received_at

    @_setIfNotNull 'browserName',              json.env_browser_name
    @_setIfNotNull 'browserVersion',           json.env_browser_version
    @_setIfNotNull 'browserMajor',             json.env_browser_major

    @_setIfNotNull 'operatingSystemName',      json.env_os_name
    @_setIfNotNull 'operatingSystemVersion',   json.env_os_version

    @_setIfNotNull 'deviceModel',              json.env_device_model
    @_setIfNotNull 'deviceType',               json.env_device_type
    @_setIfNotNull 'deviceVendor',             json.env_device_vendor

    @_setIfNotNull 'needsResponse',            json.needs_response
    @_setIfNotNull 'isOnline',                 json.is_online

    @addTyper this if json.is_typing

    @_populateAssociatedObjectWithJSON this, 'company', json.company, (json) ->
      Firehose.Company.companyWithID json.id, null, this

    super json





