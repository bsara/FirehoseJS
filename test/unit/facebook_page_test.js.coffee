module "Facebook Page"

firehoseTest 'Update', 1, (agent) ->
  company = agent.companies[0]
  facebookAccounts = company.facebookAccounts()
  facebookAccounts.next() 
  .done (data, textStatus) ->
    facebookAccount     = facebookAccounts[0]
    facebookPage        = facebookAccount.facebookPages[0]
    facebookPage.active = !facebookPage.active
    facebookPage.save()
    .done (data, textStatus) ->
      ok textStatus == "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
