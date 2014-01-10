class FirehoseJS.Client
  
  
  APIAccessToken: null
  
  URLToken: null
  
  billingAccessToken: null
  
  env: null
  
  _unauthorizedHandler: null
  
  
  constructor: ->
    this._firefoxHack()
    this._ensureEnvironment()
    
  
  setEnvironment: (environment) ->
    @env = environment
    Stripe.setPublishableKey @_environments[@env]["stripeKey"]
    
    
  get: (options) ->
    $.extend options, method: 'GET'
    this._sendRequest(options)


  post: (options) ->
    $.extend options, method: 'POST'
    this._sendRequest(options)
    
    
  put: (options) ->
    $.extend options, method: 'PUT'
    this._sendRequest(options)
    
    
  delete: (options) -> 
    $.extend options, method: 'DELETE'
    this._sendRequest(options)


  serverAddress: (server) ->
    this._ensureEnvironment()
    @_environments[@env]["#{server}URL"]
    
    
  serviceToken: (service) ->
    this._ensureEnvironment()
    @_environments[@env]["#{service}Key"]
    
  
  setUnauthorizedHandler: (callback) ->
    @_unauthorizedHandler = callback
      
    
  _sendRequest: (options) ->
    this._ensureEnvironment()
    
    defaults =
      server:   'API'   
      route:    ''
      method:   'GET'
      page:     -1
      perPage:  -1
      params:   {}
      body:     null
      
    $.extend defaults, options
    
    server  = defaults.server
    route   = defaults.route
    method  = defaults.method
    page    = defaults.page 
    perPage = defaults.perPage
    params  = defaults.params
    body    = defaults.body
    
    params["page"]      = page if page > -1      
    params["per_page"]  = perPage if perPage > -1      
    
    paramStrings = []
    for key, value of params    
      continue unless value?
      paramStrings.push "#{key}=#{value}"
       
    url = "#{this.serverAddress(server)}/#{route}"
    
    if paramStrings.length > 0
      url += "?#{paramStrings.join('&')}"
      
    headers = { "Accept" : "application/json" }
    if @APIAccessToken? and server == 'API'
      $.extend headers, { "Authorization" : "Token token=\"#{@APIAccessToken}\"" }
    else if @billingAccessToken? and server == 'billing'
      $.extend headers, { "Authorization" : "Token token=\"#{@billingAccessToken}\"" }
      
    $.ajax
      type:         method
      url:          url
      data:         JSON.stringify(body) if body
      processData:  false
      dataType:     'json'
      headers:      headers
      contentType:  'application/json'
      statusCode:
        401: =>
          @_unauthorizedHandler() if @_unauthorizedHandler?
      

  _environments:
    production:
      APIURL        : "https://api.firehoseapp.com"
      browserURL    : "https://firehoseapp.com"
      marketingURL  : "https://getfirehose.com"
      billingURL    : "https://billing.firehoseapp.com"
      stripeKey     : "pk_live_CGPaLboKkpr7tqswA4elf8NQ"
      pusherKey     : "d3e373f7fac89de7bde8"
    development:
      APIURL        : "http://localhost:3000"
      browserURL    : "http://localhost:3001"
      marketingURL  : "http://localhost:3002"
      billingURL    : "http://localhost:3003"
      stripeKey     : "pk_test_oIyMNHil987ug1v8owRhuJwr"
      pusherKey     : "2f64ac0434cc8a94526e"
    test:
      APIURL        : "http://localhost:3010"
      browserURL    : "http://localhost:3011"
      marketingURL  : "http://localhost:3012"
      billingURL    : "http://localhost:3013"
      stripeKey     : "pk_test_oIyMNHil987ug1v8owRhuJwr"
      pusherKey     : "2f64ac0434cc8a94526e"
    
    
  _ensureEnvironment: ->
    return if @env?
    anchor = document.createElement "a"
    anchor.href = document.URL
    if anchor.hostname == "localhost"
      if anchor.port == 3011
        this.setEnvironment "test"
      if anchor.port == 3021
        this.setEnvironment "production"
      else
        this.setEnvironment "development"
    else
      this.setEnvironment "production"

    
  _firefoxHack: ->
    # Firefox hack: http://api.jquery.com/jQuery.ajax/
    _super          = jQuery.ajaxSettings.xhr
    xhrCorsHeaders  = [ "Cache-Control", "Content-Language", "Content-Type", "Expires", "Last-Modified", "Pragma" ];
    jQuery.ajaxSettings.xhr = ->
      xhr = _super()
      getAllResponseHeaders = xhr.getAllResponseHeaders
      xhr.getAllResponseHeaders = ->
        allHeaders = ""
        try
          allHeaders = getAllResponseHeaders.apply( xhr )
          return allHeaders if allHeaders?
        catch e
        $.each xhrCorsHeaders, ( i, headerName ) ->
          allHeaders += "#{headerName}: #{xhr.getResponseHeader( headerName )}\n" if xhr.getResponseHeader( headerName )
          true
        return allHeaders
      return xhr
  
  
FirehoseJS.client = new FirehoseJS.Client