# @nodoc
class Firehose.Environment
  
  
  baseURLFor: (app, subdomain) ->
    this._inferEnvironmentFromURL()
    subdomain = subdomain && subdomain + "." || ""
    
    if @_environment == 'production'
      "https://#{subdomain}#{@_appDomainNames['production'][app]}"
    else if @_environment == 'beta'
      "https://#{subdomain}#{@_appBetaDomainNames[app]}"
    else
      if @_appTypes[app] == "server" and @_server != 'local'
        "https://#{subdomain}#{@_appDomainNames[@_server][app]}"
      else
        "http://#{subdomain}#{@_appDomainNames['local'][app]}:#{this._portFor(app)}"
    
    
  serviceToken: (service) ->
    this._inferEnvironmentFromURL()
    @_serviceKeys[@_environment][service]
    
    
  environment: ->
    this._inferEnvironmentFromURL()
    @_environment
  
  
  # private
  
  _server: null
  
  _environment: null
  
  _subdomain: null
  
  
  ## Port Numbers
  
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
    frhio       : 3
    marketing   : 4
    settings    : 5
    tweetlonger : 6
    kb          : 7
    
  
  ## Mappings
  
  _appDomainNames:
    local:
      API          : "localhost"
      browser      : "localhost"
      billing      : "localhost"
      frhio        : "localhost"
      marketing    : "localhost"
      settings     : "localhost"
      tweetlonger  : "localhost"
      kb           : "lvh.me"
    mini:
      API          : "199.19.84.171"
      browser      : "199.19.84.171"
      billing      : "199.19.84.171"
      frhio        : "199.19.84.171"
      marketing    : "199.19.84.171"
      settings     : "199.19.84.171"
      tweetlonger  : "199.19.84.171"
      kb           : "199.19.84.171"
    production:
      API          : "api.firehoseapp.com"
      browser      : "firehoseapp.com"
      billing      : "billing.firehoseapp.com"
      frhio        : "frh.io"
      marketing    : "getfirehose.com"
      settings     : "settings.firehoseapp.com"
      tweetlonger  : "tl.frh.io"
      kb           : "firehosehelp.com"
    
  _appBetaDomainNames:
    API          : @::_appDomainNames['production']['API']
    browser      : "beta.firehoseapp.com"
    billing      : @::_appDomainNames['production']['billing']
    frhio        : @::_appDomainNames['production']['frhio']
    marketing    : "beta.getfirehose.com"
    settings     : "beta_settings.firehoseapp.com"
    tweetlonger  : "beta_tl.frh.io"
    kb           : "firehosesupport.com"
    
  _appTypes:
    API          : "server"
    browser      : "client"
    billing      : "server"
    frhio        : "server"
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
      
  _isEnvironmentLocal:
    development:  true
    test:         true
    beta:         false
    production:   false
    
   
  ## methods      
  
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
      
          
  _portFor: (app) ->
    port = "" 
    port += @_typeNumber[@_appTypes[app]]     
    port += if @_appTypes[app] == "client" then @_serverNumber[@_server] else 0
    port += @_environmentNumber[@_environment]
    port += @_appNumber[app]
    port
    
      
  ## helpers
  
  _values: (obj) ->
    values  = []
    for key, value of obj
      values.push value
    values