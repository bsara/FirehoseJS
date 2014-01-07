class FirehoseJS.Utils
  
  APIURL: ->
    FirehoseJS.client.serverAddress 'API'
      
  browserURL: ->
    FirehoseJS.client.serverAddress 'browser'
      
  marketingURL: ->
    FirehoseJS.client.serverAddress 'marketing'
      
  billingURL: ->
    FirehoseJS.client.serverAddress 'billing'
