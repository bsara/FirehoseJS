module "Email Account"

firehoseTest 'Create', 4, (agent) ->
  company = agent.companies[0]
  emailAccount = Firehose.EmailAccount.emailAccountWithSettings company,
    emailAddress: Faker.Internet.email()
    title:        Faker.Lorem.words(1).join(" ")
    kind:         "IMAP"
    server:       "mail.example.com"
    port:         537
    username:     Faker.Internet.userName()
    password:     Faker.Lorem.words(1).join(" ")
    SSL:          true
  emailAccount.save()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok emailAccount.emailAddress?
    ok emailAccount.title?
    ok emailAccount.isForwarding?
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Update', 1, (agent) ->
  company = agent.companies[0]
  emailAccount = Firehose.EmailAccount.emailAccountWithSettings company,
    emailAddress: Faker.Internet.email()
    title:        Faker.Lorem.words(1).join(" ")
    kind:         "IMAP"
    server:       "mail.example.com"
    port:         537
    username:     Faker.Internet.userName()
    password:     Faker.Lorem.words(1).join(" ")
    SSL:          true
  emailAccount.save()
  .done (data, textStatus) ->
    emailAccount.server = "mailbox.example.com"
    emailAccount.save()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  emailAccount = Firehose.EmailAccount.emailAccountWithSettings company,
    emailAddress: Faker.Internet.email()
    title:        Faker.Lorem.words(1).join(" ")
    kind:         "IMAP"
    server:       "mail.example.com"
    port:         537
    username:     Faker.Internet.userName()
    password:     Faker.Lorem.words(1).join(" ")
    SSL:          true
  emailAccount.save()
  .done (data, textStatus) ->
    emailAccount.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
    
firehoseTest 'Guess Fields From Email', 8, (agent) ->
  company = agent.companies[0]
  emailAccount = Firehose.EmailAccount.emailAccountWithSettings company,
    emailAddress: Faker.Internet.email()
    title:        Faker.Lorem.words(1).join(" ")
    kind:         "IMAP"
    server:       "mail.example.com"
    port:         537
    username:     "test@gmail.com"
    password:     Faker.Lorem.words(1).join(" ")
    SSL:          true
  # gmail 
  emailAccount.guessFieldsFromEmail()
  ok emailAccount.kind == "IMAP"
  ok emailAccount.SSL == true
  ok emailAccount.port == 993
  ok emailAccount.server == "imap.googlemail.com"
  # hotmail
  emailAccount.username = "test@hotmail.com"
  emailAccount.guessFieldsFromEmail()
  ok emailAccount.kind == "POP"
  ok emailAccount.SSL == true
  ok emailAccount.port == 995
  ok emailAccount.server == "pop3.live.com"
  start()
  