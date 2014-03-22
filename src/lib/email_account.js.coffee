class Firehose.EmailAccount extends Firehose.Object


  # @nodoc
  @_firehoseType: "EmailAccount"

  ###
  @property [Company]
  ###
  company: null

  ###
  @property [string]
  ###
  emailAddress: null

  ###
  @property [boolean]
  ###
  isForwarding: false

  ###
  @property [string]
  ###
  title: null

  ###
  @property [string] Can be either `IMAP` or `POP`
  ###
  kind: 'IMAP'

  ###
  @property [string]
  ###
  server: null

  ###
  @property [string]
  ###
  port: null

  ###
  @property [string]
  ###
  username: null

  ###
  @property [string]
  ###
  password: null

  ###
  @property [boolean]
  ###
  SSL: true

  ###
  @property [boolean]
  ###
  deleteFromServer: false


  @emailAccountWithSettings: (company, settings) ->
    emailAccount = {}
    emailAccount.company = company
    if settings?
      emailAccount.emailAddress     = settings.emailAddress     if settings.emailAddress?
      emailAccount.title            = settings.title            if settings.title?
      emailAccount.kind             = settings.kind             if settings.kind?
      emailAccount.server           = settings.server           if settings.server?
      emailAccount.port             = settings.port             if settings.port?
      emailAccount.username         = settings.username         if settings.username?
      emailAccount.password         = settings.password         if settings.password?
      emailAccount.SSL              = settings.SSL              if settings.SSL?
      emailAccount.deleteFromServer = settings.deleteFromServer if settings.deleteFromServer?
    Firehose.Object._objectOfClassWithID Firehose.EmailAccount, emailAccount


  # @nodoc
  @_emailAccountWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.EmailAccount,
      id:      id
      company: company


  save: ->
    if @id?
      params =
        route: "email_accounts/#{@id}"
        body:  this._toJSON()
      Firehose.client.put( this, params )
    else
      params =
        route: "companies/#{@company.id}/email_accounts"
        body:  this._toJSON()
      Firehose.client.post( this, params ).done (data) =>
        this._populateWithJSON data
        @company.emailAccounts().insertObject this



  destroy: ->
    params =
      route: "email_accounts/#{@id}"
    Firehose.client.delete( this, params ).done =>
      @company.emailAccounts().dropObject this


  # @nodoc
  _popularServices: [
                        domain  : "gmail.com"
                        kind    : "IMAP"
                        SSL     : true
                        port    : 993
                        server  : "imap.googlemail.com"
                      ,
                        domain  : "hotmail.com"
                        kind    : "POP"
                        SSL     : true
                        port    : 995
                        server  : "pop3.live.com"
                      ,
                        domain  : "live.com"
                        kind    : "POP"
                        SSL     : true
                        port    : 995
                        server  : "pop3.live.com"
                      ,
                        domain  : "outlook.com"
                        kind    : "IMAP"
                        SSL     : true
                        port    : 993
                        server  : "imap-mail.outlook.com"
                      ,
                        domain  : "aol.com"
                        kind    : "IMAP"
                        SSL     : true
                        port    : 993
                        server  : "imap.aol.com"
                      ,
                        domain  : "aim.com"
                        kind    : "IMAP"
                        SSL     : true
                        port    : 993
                        server  : "imap.aim.com"
                      ,
                        domain  : "me.com"
                        kind    : "IMAP"
                        SSL     : true
                        port    : 993
                        server  : "imap.mail.me.com"
                      ,
                        domain  : "mac.com"
                        kind    : "IMAP"
                        SSL     : true
                        port    : 993
                        server  : "imap.mail.me.com"
                      ,
                        domain  : "icloud.com"
                        kind    : "IMAP"
                        SSL     : true
                        port    : 993
                        server  : "imap.mail.me.com"
                      ,
                        domain  : "yahoo.com"
                        kind    : "IMAP"
                        SSL     : true
                        port    : 993
                        server  : "imap.mail.yahoo.com"
                    ]


  guessFieldsFromEmail: ->
    if @username?.trim()
      for service in @_popularServices
        domain = "@#{service.domain}"
        if @username.indexOf( domain ) != -1
          this._setIfNotNull "kind",          service.kind
          this._setIfNotNull "SSL",           service.SSL
          this._setIfNotNull "port",          service.port
          this._setIfNotNull "server",        service.server
          this._setIfNotNull "isForwarding",  false
          @errors = []
          return true
    @errors = [ "More information needed" ]
    return false


  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "emailAddress",     json.email
    this._setIfNotNull "title",            json.title unless @title?
    this._setIfNotNull "isForwarding",     json.forwarding
    this._setIfNotNull "server",           json.incoming_server
    this._setIfNotNull "SSL",              json.incoming_ssl
    this._setIfNotNull "port",             json.incoming_port unless @port?
    this._setIfNotNull "username",         json.incoming_username
    this._setIfNotNull "kind",             json.kind
    this._setIfNotNull "deleteFromServer", json.delete_from_server
    super json


  # @nodoc
  _toJSON: ->
    email_account:
      email:              @emailAddress     if @emailAddress
      title:              @title            if @title
      forwarding:         @isForwarding     if @isForwarding?
      incoming_server:    @server           if @server
      incoming_ssl:       @SSL              if @SSL?
      incoming_port:      @port             if @port
      incoming_username:  @username         if @username
      incoming_password:  @password         if @password? && @password != "fhfakepass"
      kind:               @kind             if @kind
      delete_from_server: @deleteFromServer if @deleteFromServer?