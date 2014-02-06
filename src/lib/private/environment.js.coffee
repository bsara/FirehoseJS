# @nodoc
class Firehose.Environment
  
  
  baseURLFor: (app) ->
    this._inferEnvironmentFromURL()
    
    baseURL = ""
    
    if @_environmentSSL[@_environment]
      baseURL += "https://"
    else
      baseURL += "http://"
  
    if @_environmentLocalhost[@_environment]
      baseURL += "localhost"
    else
      baseURL += @_appHostNames[app]
      
    if @_environmentPort[@_environment]
      baseURL += ":#{this._portFor(app)}"
    
    baseURL 
    
    
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
    beta        : 3
    production  : 4
    
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
    
  _environmentSSL:
    development : false
    test        : false
    beta        : true
    production  : true
    
  _environmentPort:
    development : true
    test        : true
    beta        : false
    production  : false
  
  _environmentLocalhost:
    development : true
    test        : true
    beta        : false
    production  : false
  
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
    
    
    
    
    
  _inferEnvironmentFromURL: ->
    currentURL      = document.createElement "a"
    currentURL.href = document.URL
    
    if currentURL.hostname == "localhost" 
      typeNumber = parseInt currentURL.port[0]
      for key, value of @_typeNumber
        if value == typeNumber
          @_type = key
          
      serverNumber = parseInt currentURL.port[1]
      for key, value of @_serverNumber
        if value == serverNumber
          @_server = key
          
      environmentNumber = parseInt currentURL.port[2]
      for key, value of @_environmentNumber
        if value == environmentNumber
          @_environment = key
          
      appNumber = parseInt currentURL.port[3]
      for key, value of @_appNumber
        if value == appNumber
          @_app = key
      
    else
      @_environment = 'production'
      @_server = 'production'
      
      if currentURL.hostname.match /beta/
        @_environment = 'beta'

      appHostName = currentURL.hostname
      for key, value of @_appHostNames
        if value == appHostName
          @_app = key
          
      @_type = @_appTypes[@_app]
      
          
    
  _portFor: (app) ->
    port = "" 
    port += @_typeNumber[@_appTypes[app]]     
    port += @_serverNumber[@_server]
    port += @_environmentNumber[@_environment]
    port += @_appNumber[app]
    port
      
      
      
  