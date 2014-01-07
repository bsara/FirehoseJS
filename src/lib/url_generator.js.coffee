class FirehoseJS.URLGenerator
  
  @APIURL: ->
    FirehoseJS.client.serverAddress 'API'
      
  @browserURL: ->
    FirehoseJS.client.serverAddress 'browser'
      
  @marketingURL: ->
    FirehoseJS.client.serverAddress 'marketing'
      
  @billingURL: ->
    FirehoseJS.client.serverAddress 'billing'

  @browserLoginURL: (accessToken, id, URLToken, returnTo) ->
    url = "#{this.browserURL()}/login"
    params = []
    params.push "access_token=#{accessToken}"
    params.push "id=#{id}" if id?
    params.push "url_token=#{URLToken}" if URLToken?
    params.push "&return_to=#{encodeURIComponent(returnTo)}" if returnTo?
    if params.length > 0
      url += "?#{params.join('&')}"
    url
    
  @browserAppURL: ->
    "#{this.browserURL()}/app" 

  @browserLogoutURL: ->
    "#{this.marketingURL()}/?logout=true"
    
    
    