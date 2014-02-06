# @nodoc
class Firehose.Environment
  
  
  baseURLFor: (app) ->
    this._inferEnvironmentFromURL()
    isHostnameLocal = this._isLocalFor( app )
    if isHostnameLocal
      "http://localhost:#{this._portFor(app)}"
    else
      "https://#{@_subdomainEnvironment[@_environment]}#{@_appHostNames[@_server][app]}"
    
    
  serviceToken: (service) ->
    this._inferEnvironmentFromURL()
    @_serviceKeys[@_environment][service]
  
  
  # private
  
  _type: null
  
  _server: null
  
  _environment: null
  
  _app: null
  
  
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
  
  _appHostNames:
    local:
      API          : "localhost"
      browser      : "localhost"
      billing      : "localhost"
      frhio        : "locahost"
      marketing    : "localhost"
      settings     : "localhost"
      tweetlonger  : "localhost"
      kb           : "localhost"
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
    
  _subdomainEnvironment:
    development: ''
    test: ''
    beta: 'beta.'
    production: ''
    
      
    
  _inferEnvironmentFromURL: () ->
    currentURL      = document.createElement "a"
    currentURL.href = window.unitTestDocumentURL || document.URL
    
    if currentURL.hostname == "localhost" 
      appNumber = parseInt currentURL.port[3]
      for key, value of @_appNumber
        if value == appNumber
          @_app = key
          
      if @_appTypes[@_app] != "client" 
        throw "You're running this app on the wrong port number digit app number. See this project's README for designated port numbers for each app."
      
      typeNumber = parseInt currentURL.port[0]
      for key, value of @_typeNumber
        if value == typeNumber
          if typeNumber != 4
            throw "This is a client app, it must have the first port number digit be 4. (4***)"
          @_type = key
          
      serverNumber = parseInt currentURL.port[1]
      for key, value of @_serverNumber
        if value == serverNumber
          @_server = key
          
      environmentNumber = parseInt currentURL.port[2]
      for key, value of @_environmentNumber
        if value == environmentNumber
          if environmentNumber == 1 and @_server != "local"
            throw "It doesn't make sense to point at a remote server when running in test environment."
          @_environment = key
          
    else
      @_environment = 'production'
      @_server = 'production'
      
      if currentURL.hostname.match /beta/
        @_environment = 'beta'

      appHostName = currentURL.hostname
      for key, value of @_appHostNames[@_server]
        if value == appHostName
          @_app = key
          
      @_type = @_appTypes[@_app]
      
          
    
  _portFor: (app) ->
    port = "" 
    port += @_typeNumber[@_appTypes[app]]     
    port += if @_appTypes[app] == "client" then @_serverNumber[@_server] else 0
    port += @_environmentNumber[@_environment]
    port += @_appNumber[app]
    port
      
      
  _isLocalFor: (app) ->
    if @_appTypes[app] == "server" and @_server == "production"
      false
    else if @_isEnvironmentLocal[@_environment]
      true
    else
      false
      