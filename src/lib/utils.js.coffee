class FirehoseJS.Utils
  
  
  @APIURL: ->
    FirehoseJS.Utils._inferEnvironment()
    FirehoseJS.client.serverAddress 'API'
    
    
  @browserURL: ->
    FirehoseJS.Utils._inferEnvironment()
    FirehoseJS.client.serverAddress 'browser'
    
    
  @marketingURL: ->
    FirehoseJS.Utils._inferEnvironment()
    FirehoseJS.client.serverAddress 'marketing'
    
    
  @billingURL: ->
    FirehoseJS.Utils._inferEnvironment()
    FirehoseJS.client.serverAddress 'billing'
    
    
  @_inferEnvironment: ->
    anchor = document.createElement "a"
    anchor.href = document.URL
    if anchor.hostname == "localhost"
      FirehoseJS.client.setEnvironment "development"
    else
      FirehoseJS.client.setEnvironment "production"
    