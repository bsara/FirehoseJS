module "Facebook Account"

firehoseTest 'OAuth URL', 1, (agent) ->
  company = agent.companies[0]
  url = Firehose.FacebookAccount.OAuthURLForCompanyWithCallback( company, "test://" )
  ok url.length > 10
  start()

firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  facebookAccounts = company.facebookAccounts()
  facebookAccounts.next() 
  .done (data, textStatus) ->
    facebookAccount = facebookAccounts[0]
    facebookAccount.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
