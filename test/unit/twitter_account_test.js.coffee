module "Twitter Account"

firehoseTest 'OAuth URL', 1, (agent) ->
  company = agent.companies[0]
  url = Firehose.TwitterAccount.OAuthURLForCompanyWithCallback( company, "test://" )
  ok url.length > 10
  start()

firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  twitterAccounts = company.twitterAccounts()
  twitterAccounts.next() 
  .done (data, textStatus) ->
    facebookAccount = twitterAccounts[0]
    facebookAccount.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
