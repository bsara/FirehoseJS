# @nodoc
class Firehose.Environment
  
  
  baseURLFor: (app, subdomain) ->
    this._inferEnvironmentFromURL()
    
    scheme    = this._schemeFor app 
    subdomain = subdomain && subdomain + "." || ""
    domain    = this._domainNameFor app
    port      = this._portFor app 
    
    "#{scheme}#{subdomain}#{domain}#{port}"
    
    
  serviceToken: (service) ->
    this._inferEnvironmentFromURL()
    env = if @_server == "production" then "production" else @_environment 
    @_serviceKeys[env][service]
    
    
  environment: ->
    this._inferEnvironmentFromURL()
    @_environment
  
  
  
  
  # private
  
  _server: null
  
  _environment: null
  
  
  
  
  ## Mappings (URL Parsing)
  
  # the first digit in the port number
  _typeNumber:
    server      : 3
    client      : 4
    
  # the second number in the port number
  _serverNumber:
    local       : 0
    mini        : 1
    production  : 2
    
  # the third digit in the port number
  _environmentNumber:
    development : 0
    test        : 1
    
  # The last digit in the port number
  _appNumber:
    API         : 0
    browser     : 1
    billing     : 2
    files       : 3
    marketing   : 4
    settings    : 5
    tweetlonger : 6
    kb          : 7
    
    
    
  
  ## Mappings (URL Generation)
  
  _appDomainNames:
    API:
      development:  "localhost"
      test:         "localhost"
      beta:         "api.firehoseapp.com"
      production:   "api.firehoseapp.com"
    browser:
      development:  "localhost"
      test:         "localhost"
      beta:         "beta.firehoseapp.com"
      production:   "firehoseapp.com"
    billing:
      development:  "localhost"
      test:         "localhost"
      beta:         "billing.firehoseapp.com"
      production:   "billing.firehoseapp.com"
    files:
      development:  "localhost"
      test:         "localhost"
      beta:         "frh.io"
      production:   "frh.io"
    marketing:
      development:  "localhost"
      test:         "localhost"
      beta:         "beta.getfirehose.com"
      production:   "getfirehose.com"
    settings:
      development:  "localhost"
      test:         "localhost"
      beta:         "beta_settings.firehoseapp.com"
      production:   "settings.firehoseapp.com"
    tweetlonger:
      development:  "localhost"
      test:         "localhost"
      beta:         "beta_tl.frh.io"
      production:   "tl.frh.io"
    kb:
      development:  "lvh.me"
      test:         "lvh.me"
      beta:         "firehosesupport.com"
      production:   "firehosehelp.com"
    
  _appTypes:
    API          : "server"
    browser      : "client"
    billing      : "server"
    files        : "server"
    marketing    : "client"
    settings     : "client"
    tweetlonger  : "client"
    kb           : "client"
    
  _serviceKeys:
    development:
      stripe  : "pk_test_oIyMNHil987ug1v8owRhuJwr"
      pusher  : "2f64ac0434cc8a94526e"
    test:
      stripe  : "pk_test_oIyMNHil987ug1v8owRhuJwr"
      pusher  : "2f64ac0434cc8a94526e"
    beta:
      stripe  : "pk_live_CGPaLboKkpr7tqswA4elf8NQ"
      pusher  : "d3e373f7fac89de7bde8"
    production:
      stripe  : "pk_live_CGPaLboKkpr7tqswA4elf8NQ"
      pusher  : "d3e373f7fac89de7bde8"
      
   
   
   
  ## methods (URL parsing)
  
  _inferEnvironmentFromURL: () ->
    currentURL      = document.createElement "a"
    currentURL.href = window.unitTestDocumentURL || document.URL
    domainName      = currentURL.hostname.split('.').slice(-2).join(".")
      
    @_server      = 'production'
    @_environment = 'production'
    
    if parseInt(currentURL.port) > 0
      @_server      = 'local'
      @_environment = 'development'
      
      serverNumber = parseInt currentURL.port[1]
      for key, value of @_serverNumber
        if value == serverNumber
          @_server = key
      
      environmentNumber = parseInt currentURL.port[2]
      for key, value of @_environmentNumber
        if value == environmentNumber
          @_environment = key
      
    if currentURL.hostname.match /^beta(\.|_)/
      @_environment = 'beta'
      
      
      
  
  ## methods (URL Generation)
      
  _environmentFor: (app) ->
    if @_appTypes[app] == 'server' and @_server == 'production'
      "production"
    else
      @_environment
      
      
  _schemeFor: (app) ->
    environment = this._environmentFor app
    if environment == 'development' or environment == 'test' or app == 'kb' then "http://" else "https://"
          
          
  _domainNameFor: (app) ->
    environment = this._environmentFor app
    @_appDomainNames[app][environment]
    
          
  _portFor: (app) ->
    environment = this._environmentFor app
    return "" if environment == 'production' or environment == 'beta'
    port = ":" 
    port += @_typeNumber[@_appTypes[app]]     
    port += if @_appTypes[app] == "client" then @_serverNumber[@_server] else 0
    port += @_environmentNumber[environment]
    port += @_appNumber[app]
    port
    
      
      
      
  ## helpers
  
  _values: (obj) ->
    values  = []
    for key, value of obj
      values.push value
    values
