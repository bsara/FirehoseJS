class FirehoseJS.EmailAccount extends FirehoseJS.Object


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
    emailAccount = FirehoseJS.Object._objectOfClassWithID( FirehoseJS.EmailAccount, null )
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
    emailAccount 
    
    
  @_emailAccountWithID: (id, company) ->
    emailAccount = FirehoseJS.Object._objectOfClassWithID( FirehoseJS.EmailAccount, id )
    emailAccount.company = company
    emailAccount
    
      
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
        @kind   = service.kind
        @SSL    = service.SSL
        @port   = service.port
        @server = service.server
        return true
    return false
    
    
  _populateWithJSON: (json) ->
    @emailAddress     = json.email
    @title            ?= json.title
    @server           = json.incoming_server
    @SSL              = json.incoming_ssl
    @port             ?= json.incoming_port
    @username         = json.incoming_username
    @kind             = json.kind
    @deleteFromServer = json.delete_from_server
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