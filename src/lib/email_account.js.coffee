class FirehoseJS.EmailAccount extends FirehoseJS.Object
  

  firehoseType: "EmailAccount"

  company: null
  
  emailAddress: null
  
  title: null
  
  kind: 'IMAP'
  
  server: null
  
  port: null
  
  username: null
  
  password: null
  
  SSL: true
  
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
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.EmailAccount, emailAccount
    
    
  @_emailAccountWithID: (id, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.EmailAccount,
      id:      id
      company: company
    
      
  save: ->
    if @id?
      params = 
        route: "email_accounts/#{@id}"
        body:  this._toJSON()
      FirehoseJS.client.put( params )
    else
      params = 
        route: "companies/#{@company.id}/email_accounts"
        body:  this._toJSON()
      FirehoseJS.client.post( params ).done (data) =>
        this._populateWithJSON data
    
    
  destroy: ->
    params = 
      route: "email_accounts/#{@id}"
    FirehoseJS.client.delete( params )
    
    
  _popularServices: [
                        domain  : "gmail.com"
                        kind    : "IMAP"
                        SSL     : true
                        port    : 993
                        server  : "imap.googlemail.com"
                      ,
                        domain  : "hotmail.com",
                        kind    : "POP",
                        SSL     : true,
                        port    : 995,
                        server  : "pop3.live.com"
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
    for service in @_popularServices
      domain = "@#{service.domain}"
      if @username.indexOf( domain ) != -1
        this.setIfNotNull "kind",   service.kind
        this.setIfNotNull "SSL",    service.SSL
        this.setIfNotNull "port",   service.port
        this.setIfNotNull "server", service.server
        return true
    return false
    
    
  _populateWithJSON: (json) ->
    this.setIfNotNull "emailAddress",     json.email
    this.setIfNotNull "title",            json.title unless @title?
    this.setIfNotNull "server",           json.incoming_server
    this.setIfNotNull "SSL",              json.incoming_ssl
    this.setIfNotNull "port",             json.incoming_port unless @port?
    this.setIfNotNull "username",         json.incoming_username
    this.setIfNotNull "kind",             json.kind
    this.setIfNotNull "deleteFromServer", json.delete_from_server
    super json
    
    
  _toJSON: ->
    email_account:
      email:              @emailAddress
      title:              @title
      incoming_server:    @server
      incoming_ssl:       @SSL
      incoming_port:      @port
      incoming_username:  @username
      incoming_password:  @password
      kind:               @kind
      delete_from_server: @deleteFromServer
