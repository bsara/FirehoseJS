class Firehose.Visitor extends Firehose.Object


  # @nodoc
  @_firehoseType: "Visitor"

  ###
  @property [Firehose.Company]
  ###
  company: null

  ###
  @property [boolean]
  ###
  isBrandNew: false

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
  @property [Array<Number>]
  ###
  typers: null

  ###
  @property [boolean]
  ###
  isTyping: false

  ###
  @property [boolean]
  ###
  hasFetchedChatInteractions: false

  # remote arrays

  # @nodoc
  _chatInteractions: null


  # @nodoc
  _setup: ->
    @typers = new Firehose.UniqueArray
    @isBrandNew = true


  ###
  Create a visitor by ID so you can fetch its info and chat history from the api server.
  @param id [String] The ID of the visitor you wish to retrieve.
  @param company [Firehose.Company] The company that contains the visitor being created.
  @return [Firehose.Visitor] The visitor object that was created.
  ###
  @visitorWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.Visitor,
      id      : id
      company : company


  ###
  Create a visitor that is populated with the given properties.
  @param id [String] The ID of the visitor you wish to retrieve.
  @param company [Firehose.Company] The company that contains the visiror being created.
  @param properties [Object] The properties to apply to the visitor being created.
  @return [Firehose.Visitor] The visitor object that was created.
  ###
  @visitorWithIDAndProperties: (id, company, properties) ->
    properties.id      = id
    properties.company = company
    Firehose.Object._objectOfClassWithID Firehose.Visitor, properties


  ###
  Create a visitor from JSON pushed through the chat server socket connection.
  @param json [JSON Object]
  @param company [Firehose.Company]
  @return [Firehose.Visitor] The visitor object that was created.
  ###
  @visitorWithJSON: (json, company) ->
    visitor = Firehose.Visitor.visitorWithID json.visitor_id, company
    visitor._populateWithJSON json
    visitor


  ###
  Fetch information about this visitor that was archived to the api server by the chat
  server based on its ID.
  @return [jqXHR Promise] Promise
  ###
  fetch: (options = {}) ->
    if @id?
      request =
        route: "visitors/#{@id}"
    else
      throw "You can't call 'fetch' on a visitor unless 'id' is set."

    Firehose.client.get( this, request ).done (data) =>
      @_populateWithJSON data


  ###
  The chat interactions of the visitor.
  @return [Firehose.RemoteArray<Firehose.ChatInteraction>] The found chat interactions.
  ###
  chatInteractions: ->
    @set 'hasFetchedChatInteractions', false

    unless @_chatInteractions?
      @_setIfNotNull '_chatInteractions', new Firehose.RemoteArray "visitors/#{@id}/chat_interactions", null, (json) =>
        Firehose.ChatInteraction.chatInteractionWithID json.id, this
      @_chatInteractions.sortOn 'receivedAt'
      @set 'hasFetchedChatInteractions', true

    @_chatInteractions


  ###
  Adds a chat interaction to be connected with the visitor.
  @param chatInteraction [Firehose.ChatInteraction]
  ###
  addChatInteractionShallow: (chatInteraction) ->
    if @get 'hasFetchedChatInteractions'
      @_chatInteractions.insertObject chatInteraction


  ###
  Removes a chat interaction connected with the visitor.
  @param chatInteraction [Firehose.ChatInteraction]
  ###
  removeChatInteractionShallow: (chatInteraction) ->
    if @get 'hasFetchedChatInteractions'
      @_chatInteractions.removeObject chatInteraction


  ###
  @return [boolean] Whether or not the visitor is currently chatting with an agent.
  ###
  isCurrentlyChatting: ->
    @isOnline && @boxState == Firehose.VisitorBoxState.CHATTING


  ###
  @return [String] The location if the display name is not a real human name.
  ###
  getPreferredDisplayName: ->
    if @location?.get('length') > 0 then @location else @name


  ###
  Used when the chat server sends update information.
  @param json [JSON Object]
  ###
  updateWithJSON: (json) ->
    @_populateWithJSON json


  ###
  Adds a typer.
  @param typerAgentId [Number]
  ###
  addAgentTyper: (typerAgentId) ->
    @typers.insertObject typerAgentId


  ###
  Removes a typer.
  @param typerAgentId [Number]
  ###
  removeAgentTyper: (typerAgentId) ->
    @typers.removeObject typerAgentId


  # @nodoc
  _populateWithJSON: (json) ->
    @_setIfNotNull 'email',                    json.email
    @_setIfNotNull 'name',                     json.raw_name
    @_setIfNotNull 'avatarURL',                json.avatar_url
    @_setIfNotNull 'isTyping',                 json.is_typing
    @_setIfNotNull 'location',                 json.location_string
    @_setIfNotNull 'locationLatitude',         if json.latitude?  then json.latitude  else json.location?[0]
    @_setIfNotNull 'locationLongitude',        if json.longitude? then json.longitude else json.location?[1]
    # TODO: How to handle timeZone???
    #@_setIfNotNull 'timeZone',                 json.time_zone
    @_setIfNotNull 'referringURL',             json.referrer_url
    @_setIfNotNull 'connectedAt',              @_date json.connected_at
    @_setIfNotNull 'disconnectedAt',           @_date json.disconnected_at
    @_setIfNotNull 'currentURL',               json.current_url
    @_setIfNotNull 'ipAddress',                json.ip

    @_setIfNotNull 'customAttributes',         json.custom_attributes

    @_setIfNotNull 'visitedCurrentURLAt',      @_date json.visited_current_url_at

    @_setIfNotNull 'boxState',                 json.box_state

    @_setIfNotNull 'mostRecentChat',           json.most_recent_chat
    @_setIfNotNull 'mostRecentChatReceivedAt', @_date json.most_recent_chat_received_at

    if json.env?
      if json.env.browser?
        @_setIfNotNull 'browserName',            json.env.browser.name
        @_setIfNotNull 'browserVersion',         json.env.browser.version
        @_setIfNotNull 'browserMajor',           json.env.browser.major
      if json.env.os?
        @_setIfNotNull 'operatingSystemName',    json.env.os.name
        @_setIfNotNull 'operatingSystemVersion', json.env.os.version
      if json.env.device?
        @_setIfNotNull 'deviceModel',            json.env.device.model
        @_setIfNotNull 'deviceType',             json.env.device.type
        @_setIfNotNull 'deviceVendor',           json.env.device.vendor
    else
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

    super json
