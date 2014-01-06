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
  
  agents: new FirehoseJS.UniqueArray
  
  agentInvites: new FirehoseJS.UniqueArray
  
  tags: new FirehoseJS.UniqueArray
  
  cannedResponses: new FirehoseJS.UniqueArray
  
  
  # remote arrays
  
  _customers: null
  
  _notifications: null
  
  _twitterAccounts: null
  
  _facebookAccounts: null
  
  _emailAccounts: null
  
  
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
  
  @_creator: null
  
  
  constructor: (arg1, arg2) ->
    # with id 
    unless isNaN(parseInt(arg1))
      @id = arg1
      if arg2? and arg2.constructor == FirehoseJS.Agent
        @_creator = arg2
        @agents.push @_creator
      
    # with title and agent
    else if typeof(arg1) == 'string'
      @title = arg1
      if arg2.constructor == FirehoseJS.Agent
        @_creator = arg2
        @agents.push @_creator
    
    
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
      filter:       if criteria.resolved? and criteria.resolved then "resolved" else "unresolved"
      channel:      criteria.channels.join(",") if criteria.channels?
      sort:         criteria.sort if criteria.sort?
      search_text:  criteria.searchString if criteria.searchString
    new FirehoseJS.RemoteArray "companies/#{@id}/customers", params, (json) =>
      new FirehoseJS.Customer( json.id, this )
      
      
  notifications: ->
    unless @_notifications?
      @_notifications = new FirehoseJS.RemoteArray "companies/#{@id}/notifications", null, (json) =>
        new FirehoseJS.Notification( json.id, this )
    @_notifications
    
    
  twitterAccounts: ->
    unless @_twitterAccounts?
      @_twitterAccounts = new FirehoseJS.RemoteArray "companies/#{@id}/twitter_accounts", null, (json) =>
        new FirehoseJS.TwitterAccount( json.id, this )
    @_twitterAccounts
    
  
  facebookAccounts: ->
    unless @_facebookAccounts?
      @_facebookAccounts = new FirehoseJS.RemoteArray "companies/#{@id}/facebook_accounts", null, (json) =>
        new FirehoseJS.FacebookAccount( json.id, this )
    @_facebookAccounts
    
    
  emailAccounts: ->
    unless @_emailAccounts?
      @_emailAccounts = new FirehoseJS.RemoteArray "companies/#{@id}/email_accounts", null, (json) =>
        new FirehoseJS.EmailAccount( json.id, this )
    @_emailAccounts
             
  
  addAgent: (agent) ->
    params = 
      route: "companies/#{@id}/agents/#{agent.id}"
    FirehoseJS.client.put( params ).done =>
      @agents.push agent
    
  
  removeAgent: (agent) ->
    params = 
      route: "companies/#{@id}/agents/#{agent.id}"
    FirehoseJS.client.delete( params ).done =>
      @agents.remove agent
    
    
  fetchBillingInfo: ->
    fetchBlock = =>
      FirehoseJS.client.billingAccessToken = @token 
      params = 
        server: "billing"
        route: "entities/#{@id}"
      FirehoseJS.client.get( params ).done (json) =>
        if json.credit_card?
          @creditCard = new FirehoseJS.CreditCard( this )
          @creditCard._populateWithJSON json.credit_card
        @billingEmail           = json.email || FirehoseJS.Agent.loggedInAgent.email
        @billingRate            = json.rate / 100.0
        @trialExpirationDate    = Date.parse json.free_trial_expiration_date || new Date(+new Date + 12096e5); # 14 days away
        # @nextBillingDate        = Date.parse json.next_bill_date
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
    @title                  = json.title
    @token                  ?= json.token
    @fetchAutomatically     = json.fetch_automatically
    @lastFetchAt            = json.last_fetch_at
    @forwardingEmailAddress ?= json.forwarding_email
    @knowledgeBaseSubdomain = json.kb_subdomain
    @unresolvedCount        = json.unresolved_count
    @numberOfAccounts       = json.number_of_accounts
    
    this._populateAssociatedObjects this, "agents", json.agents, (json) ->
      agent = new FirehoseJS.Agent( json.id )
      agent.companies.push this
      agent
      
    this._populateAssociatedObjects this, "agentInvites", json.agent_invites, (json) ->
      new FirehoseJS.AgentInvite( json.id, this )
      
    this._populateAssociatedObjects this, "tags", json.tags, (json) ->
      new FirehoseJS.Tag( json.id, this )
      
    this._populateAssociatedObjects this, "cannedResponses", json.canned_responses, (json) ->
      new FirehoseJS.CannedResponse( json.id, this )
      
    FirehoseJS.client.billingAccessToken = @token
    
    super json
    
    
  _toJSON: ->
    company:
      title:                @title
      fetch_automatically:  @fetchAutomatically
      