class FirehoseJS.Company extends FirehoseJS.Object
  
  
  title: null
  
  token: null
  
  lastFetchAt: null
  
  fetchAutomatically: true
  
  forwardingEmailAddress: null
  
  knowledgeBaseSubdomain: null
  
  unresolvedCount: 0
  
  numberOfAccounts: 0
  
  
  # associations
  
  agents: null
  
  agentInvites: null
  
  tags: null
  
  cannedResponses: null
  
  
  # remote arrays
  
  _customers: null
  
  _notifications: null
  
  _twitterAccounts: null
  
  _facebookAccounts: null
  
  _emailAccounts: null
  
  _articles: null
  
  
  # billing
  
  creditCard: null
  
  billingEmail: null
  
  billingRate: 8.0
  
  trialExpirationDate: null
  
  nextBillingDate: null
  
  isGracePeriodOver: false
  
  daysLeftInGracePeriod: -1
  
  isCurrent: false
  
  hasSuccessfulBilling: false
  
  
  # protected
  
  _creator: null
    
    
  setup: ->
    @agents           = new FirehoseJS.UniqueArray
    @agentInvites     = new FirehoseJS.UniqueArray
    @tags             = new FirehoseJS.UniqueArray
    @cannedResponses  = new FirehoseJS.UniqueArray

    @agents.sortOn "firstName"
    @tags.sortOn "label"
    @cannedResponses.sortOn "name"
    
    
  @companyWithTitle: (title, creator) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Company,
      title:    title
      _creator: creator
  
  
  @companyWithID: (id, creator) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.Company,
      id:       id
      _creator: creator
    
    
  fetch: ->
    params = 
      route: "companies/#{@id}"
    FirehoseJS.client.get( params ).done (data) =>
      this._populateWithJSON data
 
  
  save: ->
    if @id?
      params = 
        route: "companies/#{@id}"
        body:  this._toJSON()
      FirehoseJS.client.put( params )
    else
      params = 
        route: "agents/#{@_creator.id}/companies"
        body:  this._toJSON()
      FirehoseJS.client.post( params ).done (data) =>
        this._populateWithJSON data
    
    
  forceChannelsFetch: ->
    params = 
      route: "companies/#{@id}/force_channels_fetch"
    FirehoseJS.client.put( params )
    
    
  destroy: ->
    params = 
      route: "companies/#{@id}"
    FirehoseJS.client.delete( params )
    
    
  customersWithCriteria: (criteria) ->
    criteria ?= {}
    params =
      filter:       if criteria.everything? and criteria.everything then "everything" else "unresolved"
      channel:      criteria.channels.join(",") if criteria.channels?
      sort:         if criteria.sort? then criteria.sort else "newest_first"
      search_text:  encodeURIComponent( criteria.searchString ) if criteria.searchString
    customers = new FirehoseJS.RemoteArray "companies/#{@id}/customers", params, (json) =>
      FirehoseJS.Customer.customerWithID( json.id, this )
    if params.sort == 'newest_first'
      customers.sortOn "newestInteractionReceivedAt", "desc"
    else
      customers.sortOn "newestInteractionReceivedAt", "asc"
    customers
      
      
  notifications: ->
    unless @_notifications?
      this.setIfNotNull "_notifications", new FirehoseJS.RemoteArray "companies/#{@id}/notifications", null, (json) =>
        FirehoseJS.Notification._notificationWithID( json.id, this )
      @_notifications.sortOn "title"
    @_notifications
    
    
  twitterAccounts: ->
    unless @_twitterAccounts?
      this.setIfNotNull "_twitterAccounts", new FirehoseJS.RemoteArray "companies/#{@id}/twitter_accounts", null, (json) =>
        FirehoseJS.TwitterAccount._twitterAccountWithID( json.id, this )
      @_twitterAccounts.sortOn "screenName"
    @_twitterAccounts
    
  
  facebookAccounts: ->
    unless @_facebookAccounts?
      this.setIfNotNull "_facebookAccounts", new FirehoseJS.RemoteArray "companies/#{@id}/facebook_accounts", null, (json) =>
        FirehoseJS.FacebookAccount._facebookAccountWithID( json.id, this )
      @_facebookAccounts.sortOn "name"
    @_facebookAccounts
    
    
  emailAccounts: ->
    unless @_emailAccounts?
      this.setIfNotNull "_emailAccounts", new FirehoseJS.RemoteArray "companies/#{@id}/email_accounts", null, (json) =>
        FirehoseJS.EmailAccount._emailAccountWithID( json.id, this )
      @_emailAccounts.sortOn "username"
    @_emailAccounts
    
    
  articles: ->
    unless @_articles?
      this.setIfNotNull "_articles", new FirehoseJS.RemoteArray "companies/#{@id}/articles", null, (json) =>
        FirehoseJS.Article.articleWithID( json.id, this )
      @_articles.sortOn "title"
    @_articles
             
  
  addAgent: (agent) ->
    params = 
      route: "companies/#{@id}/agents/#{agent.id}"
    FirehoseJS.client.put( params ).done =>
      @agents.insertObject agent
    
  
  removeAgent: (agent) ->
    params = 
      route: "companies/#{@id}/agents/#{agent.id}"
    FirehoseJS.client.delete( params ).done =>
      @agents.dropObject agent
    
    
  fetchBillingInfo: ->
    fetchBlock = =>
      FirehoseJS.client.billingAccessToken = @token 
      params = 
        server: "billing"
        route: "entities/#{@id}"
      FirehoseJS.client.get( params ).done (json) =>
        if json.credit_card?
          this.setIfNotNull "creditCard", FirehoseJS.CreditCard.creditCardWithID( json.credit_card.id, this )
          @creditCard._populateWithJSON json.credit_card
        this.setIfNotNull "billingEmail",        json.email || FirehoseJS.Agent.loggedInAgent.email
        this.setIfNotNull "billingRate",         json.rate / 100.0
        this.setIfNotNull "trialExpirationDate", Date.parse json.free_trial_expiration_date || new Date(+new Date + 12096e5) # 14 days away
        # nextBillingDate        = Date.parse json.next_bill_date
        # @isGracePeriodOver      = json.grace_period_over
        # @daysLeftInGracePeriod  = json.days_left_in_grace_period
        # @isCurrent              = json.current
        # @hasSuccessfulBilling   = json.has_successful_billing
        
    if @token
      fetchBlock()
    else
      this.fetch().then ->
        fetchBlock()
    
    
  _populateWithJSON: (json) ->
    this.setIfNotNull "title",                  json.title
    this.setIfNotNull "token",                  json.token               unless @token?
    this.setIfNotNull "fetchAutomatically",     json.fetch_automatically
    this.setIfNotNull "lastFetchAt",            json.last_fetch_at
    this.setIfNotNull "forwardingEmailAddress", json.forwarding_email    unless @forwardingEmailAddress?
    this.setIfNotNull "knowledgeBaseSubdomain", json.kb_subdomain
    this.setIfNotNull "unresolvedCount",        json.unresolved_count
    this.setIfNotNull "numberOfAccounts",       json.number_of_accounts
    
    this._populateAssociatedObjects this, "agents", json.agents, (json) =>
      agent = FirehoseJS.Agent.agentWithID( json.id )
      agent.companies.insertObject this
      agent
      
    this._populateAssociatedObjects this, "agentInvites", json.agent_invites, (json) =>
      FirehoseJS.AgentInvite._agentInviteWithID( json.id, this )
      
    this._populateAssociatedObjects this, "tags", json.tags, (json) =>
      FirehoseJS.Tag._tagWithID( json.id, this )
      
    this._populateAssociatedObjects this, "cannedResponses", json.canned_responses, (json) =>
      FirehoseJS.CannedResponse._cannedResponseWithID( json.id, this )
      
    FirehoseJS.client.billingAccessToken = @token
    
    super json
    
    
  _toJSON: ->
    company:
      title:                @title
      fetch_automatically:  @fetchAutomatically
      
