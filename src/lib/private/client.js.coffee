class Firehose.Client
  
  ###
  @property [hash] A hash of http status codes that could be returned by the API server and functions to handle them.
  @example Assigning this a hash with a 401 status code to handle an unauthorized request:
    Firehose.client.statusCodeHandlers =
      401: =>
        this.logout()
      422: (jqXHR, textStatus, errorThrown) ->
        …
  ###
  statusCodeHandlers: null
  
  ###
  @property [Function(jqXHR, textStatus, errorThrown)] A function that is called whenever a call to the API service fails.
  ###
  errorHandler: null
  
  # @nodoc
  APIAccessToken: null
  
  # @nodoc
  URLToken: null
  
  # @nodoc
  billingAccessToken: null
  
  # @nodoc
  environment: null
  
  
  # @nodoc
  constructor: ->
    this._firefoxHack()
    @environment = new Firehose.Environment
    Stripe.setPublishableKey @environment.serviceToken('stripe')
    
    
  # @nodoc
  get: (object, options) ->
    $.extend options, method: 'GET'
    this._sendRequest object, options


  # @nodoc
  post: (object, options) ->
    $.extend options, method: 'POST'
    this._sendRequest object, options
    
    
  # @nodoc
  put: (object, options) ->
    $.extend options, method: 'PUT'
    this._sendRequest object, options
    
    
  # @nodoc
  delete: (object, options) -> 
    $.extend options, method: 'DELETE'
    this._sendRequest object, options
    
  
  # @nodoc
  _sendRequest: (object, options) ->
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
      "Accept" : "application/json"
      "X-Firehose-Environment" : "beta" if this.environment.environment() == 'beta'
    
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
      statusCode:   if server == 'API' then @statusCodeHandlers || {}
      
    .fail (jqXHR, textStatus, errorThrown) =>
      if server == 'API'
        # call the error handler if available
        @errorHandler jqXHR, textStatus, errorThrown if @errorHandler?
        # set the errors on the object if possible
        if Number(jqXHR.status) == 422 and jqXHR.responseJSON? and object?
          json = jqXHR.responseJSON
          if json.constructor == Object
            delete object.errors
            for key, errors of jqXHR.responseJSON 
              object.errors.push "#{this._humanize(key)} #{errors.join ', '}"
          else if json.constructor == Array
            object.errors = json
          else
            object.errors = "#{json}".split("\n")


  # @nodoc
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
      
      
  # @nodoc
  _humanize: (str) ->
    str.replace(/_id$/, '').replace(/_/g, ' ').replace /^\w/g, (s) ->
      s.toUpperCase()


###
A few methods are publicized on the client, although a mostly private object used internally.
@return [Client] The client singleton used by firehose.js internally.
###
Firehose.client = new Firehose.Client
