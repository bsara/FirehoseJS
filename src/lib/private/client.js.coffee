# @nodoc
class Firehose.Client
  
  
  APIAccessToken: null
  
  URLToken: null
  
  billingAccessToken: null
  
  statusCodeHandlers: null
  
  environment: null
  
  
  constructor: ->
    this._firefoxHack()
    @environment = new Firehose.Environment
    Stripe.setPublishableKey @environment.serviceToken('stripe')
    
    
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
    
  
  _sendRequest: (options) ->
    defaults =
      server:   'API'   
      auth:     true
      route:    ''
      method:   'GET'
      page:     -1
      perPage:  -1
      params:   {}
      body:     null
      
    $.extend defaults, options
    
    server  = defaults.server
    auth    = defaults.auth
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
      paramStrings.push "#{key}=#{encodeURIComponent(value)}"
       
    url = "#{@environment.baseURLFor(server)}/#{route}"
    
    if paramStrings.length > 0
      url += "?#{paramStrings.join('&')}"
      
    headers = 
      "Accept"                : "application/json",
      "X-Firehose-Environment"  : this.environment.environment()
    
    if auth
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
      statusCode:   @statusCodeHandlers || {}

      
    
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
  
  
Firehose.client = new Firehose.Client